# This file is autogenerated. Do not edit it by hand. Regenerate it with:
#   srb rbi gems

# typed: strict
#
# If you would like to make changes to this file, great! Please create the gem's shim here:
#
#   https://github.com/sorbet/sorbet-typed/new/master?filename=lib/ip3country/all/ip3country.rbi
#
# ip3country-0.1.1

module CountryLookup
  def self.initialize; end
  def self.lookup_ip_number(ip_number); end
  def self.lookup_ip_string(ip_string); end
end
class CountryLookup::Lookup
  def binary_search(value); end
  def initialize; end
  def initialize_from_file; end
  def lookup_ip_number(ip_number); end
  def lookup_ip_string(ip_string); end
end