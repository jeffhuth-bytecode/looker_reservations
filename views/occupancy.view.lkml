view: occupancy {

  # dimension: primary_key {
  #   type: string
  #   primary_key: yes
  #   hidden: yes
  #   sql: GENERATE_UUID() ;;
  # }

  measure: unit_capacity {
    description: "Total Units x Days"
    type: number
    value_format_name: decimal_0
    drill_fields: [details*]
    sql: ${calendar_date.count} * ${buildings.total_units} ;;
  }

  measure: occupancy_rate {
    description: "Checked-in Completed Reservations / Unit Capacity"
    type: number
    value_format_name: percent_2
    drill_fields: [details*]
    sql: 1.0 * ${reservations.count_completed} / NULLIF(${unit_capacity}, 0) ;;
  }

  set: details {
    fields: [
      buildings.building_name,
      buildings.metro,
      reservations.bd_ba,
      reservations.reservation_status,
      reservations.booking_source,
      reservations.booking_date,
      reservations.check_in_date,
      reservations.check_out_date,
      reservations.duration_days,
      reservations.revenue
    ]
  }

}
