# Run only by the nightly integration workflow, against real cloud credentials.
run "apply_minimal" {
  command = apply

  module {
    source = "./examples/minimal"
  }

  assert {
    condition     = output.id != null && output.route_table_association_id != null
    error_message = "Minimal example must create the subnet and associate it with the route table."
  }
}
