# Changelog

## [0.2.0](https://github.com/Olensys/terraform-aws-subnet/compare/v0.1.0...v0.2.0) (2026-11-01)


### Features

* gate the route table association on create_route_table_association ([#3](https://github.com/Olensys/terraform-aws-subnet/issues/3)) ([1a0c593](https://github.com/Olensys/terraform-aws-subnet/commit/1a0c593234f56e2c5b031c3cd041ac1b4761f978))

### Behaviour changes

- The route table association is created only when `create_route_table_association = true`; `route_table_id` on its own no longer creates it. Callers of 0.1.0 that pass `route_table_id` must add `create_route_table_association = true`, otherwise the next apply removes the association.

## 0.1.0 (2026-10-29)


### Features

* initial module ([#1](https://github.com/Olensys/terraform-aws-subnet/issues/1)) ([9b77868](https://github.com/Olensys/terraform-aws-subnet/commit/9b77868b726d3416660bdb8b2e8f57b0baba9c8c))

## Changelog
