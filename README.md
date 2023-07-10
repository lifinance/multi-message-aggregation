
# LI.FI Multi Message Aggregator

## Background
LI.FI Multi Message Aggregator (AMA) is a cross-chain Arbitrary Message Bridge (AMB) aggregator. The communication layer underpinning different blockchains are heavily conflicting at their interface level. LI.FI aggregator aims to provide a common yet simpler interface for developers to build cross-chain applications in a more modular & secure approach.

This project inherits part of its architecture from [Kydo's MMA Implementation](https://github.com/MultiMessageAggregation/multibridge)

## Build & Install
The aggregator at this point supports only evm-based blockchains and hence is built using solidity. To run this repository in your local, please install [foundry](https://book.getfoundry.sh/getting-started/installation).

After installing foundry, run the following command to compile the repository,

```rust
  forge compile
```

To run tests,

```rust
  forge test -vvv
```
## Infrastructure
To know more about LI.FI's AMA, please refer the following,
-  [FIGJAM Architecture Diagram](https://www.figma.com/file/xgIvh2AfCSoCzG7tHxKBb6/LI.FI-MMA?type=whiteboard&node-id=3-1060&t=JGcm9ChgOwb3QC8s-0)

## Contributing
TBD

## License
TBD

## Maintainers
- [@sujithsomraaj](https://www.github.com/sujithsomraaj)
