# Dependency Injection: Good and Less Ideal Uses

## Good Uses

- **Injecting network services** - Allows swapping real and mock implementations for testing
- **Injecting data repositories** - Decouples view models from concrete data sources
- **Injecting view models** - Allows providing mocked view models during testing
- **Configuring image caching** - Can inject different cache settings based on environment

## Less Ideal Uses

- **Injecting small utility classes** - Adds unnecessary complexity for simple dependencies
- **Injecting view components** - Views don't often have dependencies, so DI provides less benefit
- **Singletons or app-wide instances** - DI works best for scoped dependencies vs singletons
- **Tightly coupled classes** - If classes are tightly coupled, DI won't help decouple them

