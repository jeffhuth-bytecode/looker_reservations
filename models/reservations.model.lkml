connection: "case_study_big_query"

# include all the views
include: "/views/**/*.view"

datagroup: reservations_default_datagroup {
  max_cache_age: "12 hours"
}

persist_with: reservations_default_datagroup

explore: buildings {}

# explore: guest_analysis {}

explore: reservations {
  join: buildings {
    type: left_outer
    relationship: many_to_one
    sql_on: ${reservations.building_name} = ${buildings.building_name} ;;
  }
  join: guest_analysis {
    type: left_outer
    relationship: many_to_one
    sql_on: ${reservations.guest_id} = ${guest_analysis.guest_id} ;;
  }
}

explore: occupancy {
  view_name: calendar_date
  view_label: "Calendar Date"
  join: buildings {
    type: cross
    relationship: one_to_many
  }
  join: reservations {
    type: left_outer
    relationship: one_to_many
    sql_on: ${calendar_date.calendar_raw} >= ${reservations.check_in_raw}
            AND ${calendar_date.calendar_raw} < ${reservations.check_out_raw}
            AND ${buildings.building_name} = ${reservations.building_name} ;;
  }
  join: guest_analysis {
    type: left_outer
    relationship: many_to_one
    sql_on: ${reservations.guest_id} = ${guest_analysis.guest_id} ;;
  }
  join: occupancy {
    required_joins: [buildings, reservations]
    relationship: one_to_one
    sql:  ;;
  }
}
