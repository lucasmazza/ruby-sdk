

require_relative 'hash_utils'
# require 'sorbet-runtime'


module ClientInitializeHelpers
  class ResponseFormatter
    # extend T::Sig

    def initialize(evaluator, user, hash, client_sdk_key)
      @evaluator = evaluator
      @user = user
      @specs = evaluator.spec_store.get_raw_specs
      @hash = hash
      @client_sdk_key = client_sdk_key
    end

    def get_responses(key)
      @specs[key]
        .map { |name, spec| to_response(name, spec) }
        .delete_if { |v| v.nil? }.to_h
    end

    private

    # sig { params(secondary_exposures: T::Array[T::Hash[String, String]]).returns(T::Array[T::Hash[String, String]]) }
    def filter_segments_from_secondary_exposures(secondary_exposures)
      secondary_exposures.reject do |exposure|
        exposure['gate'].to_s.start_with?('segment:')
      end
    end

    def to_response(config_name, config_spec)
      target_app_id = @evaluator.spec_store.get_app_id_for_sdk_key(@client_sdk_key)
      config_target_apps = config_spec['targetAppIDs']

      unless target_app_id.nil? || (!config_target_apps.nil? && config_target_apps.include?(target_app_id))
        return nil
      end

      eval_result = @evaluator.eval_spec(@user, config_spec)
      if eval_result.nil?
        return nil
      end

      category = config_spec['type']
      entity_type = config_spec['entity']

      result = {}

      case category

      when 'feature_gate'
        if entity_type == 'segment' || entity_type == 'holdout'
          return nil
        end

        result['value'] = eval_result.gate_value
        result["group_name"] = eval_result.group_name
        result["id_type"] = eval_result.id_type
      when 'dynamic_config'
        id_type = config_spec['idType']
        result['value'] = eval_result.json_value
        result["group"] = eval_result.rule_id
        result["group_name"] = eval_result.group_name
        result["id_type"] = eval_result.id_type
        result["is_device_based"] = id_type.is_a?(String) && id_type.downcase == 'stableid'
      else
        return nil
      end

      if entity_type == 'experiment'
        populate_experiment_fields(config_name, config_spec, eval_result, result)
      end

      if entity_type == 'layer'
        populate_layer_fields(config_spec, eval_result, result)
        result.delete('id_type') # not exposed for layer configs in /initialize
      end

      hashed_name = hash_name(config_name)
      [hashed_name, result.merge(
        {
          "name" => hashed_name,
          "rule_id" => eval_result.rule_id,
          "secondary_exposures" => clean_exposures(eval_result.secondary_exposures)
        }).compact]
    end

    def clean_exposures(exposures)
      seen = {}
      exposures.reject do |exposure|
        key = "#{exposure["gate"]}|#{exposure["gateValue"]}|#{exposure["ruleID"]}}"
        should_reject = seen[key]
        seen[key] = true
        should_reject == true
      end
    end

    def populate_experiment_fields(config_name, config_spec, eval_result, result)
      result["is_user_in_experiment"] = eval_result.is_experiment_group
      result["is_experiment_active"] = config_spec['isActive'] == true

      if config_spec['hasSharedParams'] != true
        return
      end

      result["is_in_layer"] = true
      result["explicit_parameters"] = config_spec["explicitParameters"] || []

      layer_name = @specs[:experiment_to_layer][config_name]
      if layer_name.nil? || @specs[:layers][layer_name].nil?
        return
      end

      layer = @specs[:layers][layer_name]
      result["value"] = layer["defaultValue"].merge(result["value"])
    end

    def populate_layer_fields(config_spec, eval_result, result)
      delegate = eval_result.config_delegate
      result["explicit_parameters"] = config_spec["explicitParameters"] || []

      if delegate.nil? == false && delegate.empty? == false
        delegate_spec = @specs[:configs][delegate]
        delegate_result = @evaluator.eval_spec(@user, delegate_spec)

        result["allocated_experiment_name"] = hash_name(delegate)
        result["is_user_in_experiment"] = delegate_result.is_experiment_group
        result["is_experiment_active"] = delegate_spec['isActive'] == true
        result["explicit_parameters"] = delegate_spec["explicitParameters"] || []
      end

      result["undelegated_secondary_exposures"] = clean_exposures(eval_result.undelegated_sec_exps || [])
    end

    def hash_name(name)
      case @hash
      when 'none'
        return name
      when 'sha256'
        return Statsig::HashUtils.sha256(name)
      when 'djb2'
        return Statsig::HashUtils.djb2(name)
      end
    end
  end
end
