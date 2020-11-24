view: guest_analysis {
  derived_table: {
    explore_source: reservations {
      column: guest_id {}
      column: min_booking_date {}
      column: max_booking_date {}
      column: min_check_in_date {}
      column: max_check_in_date {}
      column: min_check_out_date {}
      column: max_check_out_date {}
      column: total_revenue {}
      column: count {}
      column: total_duration {}
    }
  }

  dimension: guest_id {
    primary_key: yes
    description: "Unique ID assigned to each Kasa guest"
  }
  dimension: min_booking_date {
    type: number
  }
  dimension: max_booking_date {
    type: number
  }
  dimension: min_check_in_date {
    type: number
  }
  dimension: max_check_in_date {
    type: number
  }
  dimension: min_check_out_date {
    type: number
  }
  dimension: max_check_out_date {
    type: number
  }
  dimension: total_revenue {
    label: "Reservations Revenue $"
    value_format: "$#,##0"
    type: number
  }
  dimension: count {
    type: number
  }
  dimension: total_duration {
    value_format: "#,##0.0"
    type: number
  }

  dimension: is_first_booking {
    view_label: "Reservations"
    type: yesno
    sql: ${min_booking_date} = ${reservations.booking_date} ;;
  }

  dimension: new_repeat_customer {
    view_label: "Reservations"
    type: yesno
    sql: CASE WHEN ${min_booking_date} = ${reservations.booking_date} THEN 'New'
          ELSE 'Repeat' END ;;
  }
}
