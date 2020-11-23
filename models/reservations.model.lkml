connection: "case_study_big_query"

# include all the views
include: "/views/**/*.view"

datagroup: reservations_default_datagroup {
  max_cache_age: "12 hours"
}

persist_with: reservations_default_datagroup

explore: buildings {}

explore: reservations {
  join: buildings {
    type: left_outer
    relationship: many_to_one
    sql_on: ${reservations.building_name} = ${buildings.building_name} ;;
  }
}
