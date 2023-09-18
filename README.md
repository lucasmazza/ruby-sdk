# Statsig Ruby Server SDK

[![build-and-test](https://github.com/statsig-io/ruby-sdk/actions/workflows/build-and-test.yml/badge.svg?branch=main)](https://github.com/statsig-io/private-ruby-sdk/actions/workflows/build-and-test.yml)

The Statsig Ruby SDK for multi-user, server side environments. If you need a SDK for another language or single user client environment, check out our [other SDKs](https://docs.statsig.com/#sdks).

Statsig helps you move faster with Feature Gates (Feature Flags) and Dynamic Configs. It also allows you to run A/B tests to validate your new features and understand their impact on your KPIs. If you're new to Statsig, create an account at [statsig.com](https://www.statsig.com).

## Getting Started

Check out our [SDK docs](https://docs.statsig.com/server/rubySDK) to get started.

## Testing

Each server SDK is tested at multiple levels - from unit to integration and e2e tests. Our internal e2e test harness runs daily against each server SDK, while unit and integration tests can be seen in the respective github repos of each SDK. The `server_sdk_consistency_test` runs a validation test on local rule/condition evaluation for this SDK against the results in the statsig backend.
