CREATE VIEW dssview.stopregistry_access_space AS
    SELECT
        level_ref_version,
        id,
        centroid,
        version_comment,
        description_lang,
        version,
        all_areas_wheelchair_accessible,
        covered,
        place_equipments_id,
        accessibility_assessment_id,
        polygon_id,
        changed_by,
        label_value,
        label_lang,
        site_ref_version,
        description_value,
        site_ref,
        name_lang,
        name_value,
        private_code_type,
        private_code_value,
        short_name_lang,
        short_name_value,
        level_ref,
        changed,
        netex_id,
        created,
        from_date,
        to_date
    FROM stopregistry.access_space;
CREATE VIEW dssview.stopregistry_access_space_alternative_names AS
    SELECT
        access_space_id,
        alternative_names_id
    FROM stopregistry.access_space_alternative_names;
CREATE VIEW dssview.stopregistry_access_space_check_constraints AS
    SELECT
        check_constraints_id,
        access_space_id
    FROM stopregistry.access_space_check_constraints;
CREATE VIEW dssview.stopregistry_access_space_equipment_places AS
    SELECT
        access_space_id,
        equipment_places_id
    FROM stopregistry.access_space_equipment_places;
CREATE VIEW dssview.stopregistry_access_space_key_values AS
    SELECT
        key_values_key,
        key_values_id,
        access_space_id
    FROM stopregistry.access_space_key_values;
CREATE VIEW dssview.stopregistry_accessibility_assessment AS
    SELECT
        id,
        changed,
        created,
        from_date,
        hsl_accessibility_properties_id,
        netex_id,
        version,
        changed_by,
        to_date,
        mobility_impaired_access,
        version_comment
    FROM stopregistry.accessibility_assessment;
CREATE VIEW dssview.stopregistry_accessibility_assessment_limitations AS
    SELECT
        accessibility_assessment_id,
        limitations_id
    FROM stopregistry.accessibility_assessment_limitations;
CREATE VIEW dssview.stopregistry_accessibility_limitation AS
    SELECT
        version,
        netex_id,
        version_comment,
        audible_signals_available,
        escalator_free_access,
        lift_free_access,
        step_free_access,
        visual_signs_available,
        wheelchair_access,
        changed_by,
        id,
        changed,
        created,
        from_date,
        to_date
    FROM stopregistry.accessibility_limitation;
CREATE VIEW dssview.stopregistry_alternative_name AS
    SELECT
        changed,
        short_name_lang,
        qualifier_name_value,
        qualifier_name_lang,
        name_type,
        name_value,
        name_lang,
        id,
        lang,
        created,
        from_date,
        named_object_ref,
        to_date,
        version,
        abbreviation_value,
        netex_id,
        version_comment,
        abbreviation_lang,
        type_of_name,
        changed_by,
        short_name_value
    FROM stopregistry.alternative_name;
CREATE VIEW dssview.stopregistry_boarding_position AS
    SELECT
        site_ref_version,
        label_value,
        boarding_position_type,
        public_code,
        changed_by,
        changed,
        all_areas_wheelchair_accessible,
        covered,
        site_ref,
        label_lang,
        netex_id,
        version_comment,
        polygon_id,
        accessibility_assessment_id,
        description_value,
        place_equipments_id,
        version,
        to_date,
        from_date,
        name_lang,
        name_value,
        id,
        centroid,
        created,
        description_lang,
        private_code_type,
        private_code_value,
        short_name_lang,
        short_name_value,
        level_ref,
        level_ref_version
    FROM stopregistry.boarding_position;
CREATE VIEW dssview.stopregistry_boarding_position_alternative_names AS
    SELECT
        boarding_position_id,
        alternative_names_id
    FROM stopregistry.boarding_position_alternative_names;
CREATE VIEW dssview.stopregistry_boarding_position_check_constraints AS
    SELECT
        boarding_position_id,
        check_constraints_id
    FROM stopregistry.boarding_position_check_constraints;
CREATE VIEW dssview.stopregistry_boarding_position_equipment_places AS
    SELECT
        equipment_places_id,
        boarding_position_id
    FROM stopregistry.boarding_position_equipment_places;
CREATE VIEW dssview.stopregistry_boarding_position_key_values AS
    SELECT
        key_values_key,
        key_values_id,
        boarding_position_id
    FROM stopregistry.boarding_position_key_values;
CREATE VIEW dssview.stopregistry_check_constraint AS
    SELECT
        id,
        changed_by,
        version_comment,
        changed,
        description_id,
        version,
        to_date,
        name_id,
        from_date,
        netex_id,
        created
    FROM stopregistry.check_constraint;
CREATE VIEW dssview.stopregistry_check_constraint_key_values AS
    SELECT
        key_values_id,
        check_constraint_id,
        key_values_key
    FROM stopregistry.check_constraint_key_values;
CREATE VIEW dssview.stopregistry_contact AS
    SELECT
        version_comment,
        netex_id,
        changed_by,
        contact_person,
        email,
        phone,
        fax,
        url,
        further_details,
        from_date,
        created,
        id,
        changed,
        version,
        to_date
    FROM stopregistry.contact;
CREATE VIEW dssview.stopregistry_destination_display_view AS
    SELECT
        public_code,
        name_id,
        branding_ref,
        id,
        short_code
    FROM stopregistry.destination_display_view;
CREATE VIEW dssview.stopregistry_equipment_place AS
    SELECT
        short_name_value,
        private_code_value,
        private_code_type,
        name_value,
        changed,
        name_lang,
        description_value,
        description_lang,
        to_date,
        version,
        polygon_id,
        centroid,
        version_comment,
        changed_by,
        short_name_lang,
        from_date,
        created,
        id,
        netex_id
    FROM stopregistry.equipment_place;
CREATE VIEW dssview.stopregistry_equipment_place_equipment_positions AS
    SELECT
        equipment_positions_id,
        equipment_place_id
    FROM stopregistry.equipment_place_equipment_positions;
CREATE VIEW dssview.stopregistry_equipment_place_key_values AS
    SELECT
        equipment_place_id,
        key_values_key,
        key_values_id
    FROM stopregistry.equipment_place_key_values;
CREATE VIEW dssview.stopregistry_equipment_position AS
    SELECT
        from_date,
        netex_id,
        version_comment,
        reference_point_ref,
        version,
        description_id,
        y_offset,
        x_offset,
        id,
        changed_by,
        changed,
        reference_point_version,
        created,
        to_date
    FROM stopregistry.equipment_position;
CREATE VIEW dssview.stopregistry_equipment_position_key_values AS
    SELECT
        key_values_key,
        equipment_position_id,
        key_values_id
    FROM stopregistry.equipment_position_key_values;
CREATE VIEW dssview.stopregistry_fare_zone AS
    SELECT
        created,
        scoping_method,
        zone_topology,
        changed_by,
        short_name_value,
        short_name_lang,
        private_code_value,
        private_code_type,
        name_value,
        name_lang,
        description_value,
        description_lang,
        version_comment,
        netex_id,
        id,
        changed,
        from_date,
        to_date,
        version,
        centroid,
        transport_organisation_ref,
        polygon_id
    FROM stopregistry.fare_zone;
CREATE VIEW dssview.stopregistry_fare_zone_key_values AS
    SELECT
        key_values_id,
        fare_zone_id,
        key_values_key
    FROM stopregistry.fare_zone_key_values;
CREATE VIEW dssview.stopregistry_fare_zone_members AS
    SELECT
        fare_zone_id,
        ref,
        version
    FROM stopregistry.fare_zone_members;
CREATE VIEW dssview.stopregistry_fare_zone_neighbours AS
    SELECT
        version,
        ref,
        fare_zone_id
    FROM stopregistry.fare_zone_neighbours;
CREATE VIEW dssview.stopregistry_group_of_stop_places AS
    SELECT
        created,
        description_value,
        name_lang,
        private_code_type,
        private_code_value,
        short_name_lang,
        short_name_value,
        name_value,
        netex_id,
        changed_by,
        version_comment,
        id,
        description_lang,
        changed,
        purpose_of_grouping_id,
        centroid,
        version,
        to_date,
        from_date
    FROM stopregistry.group_of_stop_places;
CREATE VIEW dssview.stopregistry_group_of_stop_places_alternative_names AS
    SELECT
        alternative_names_id,
        group_of_stop_places_id
    FROM stopregistry.group_of_stop_places_alternative_names;
CREATE VIEW dssview.stopregistry_group_of_stop_places_key_values AS
    SELECT
        key_values_id,
        group_of_stop_places_id,
        key_values_key
    FROM stopregistry.group_of_stop_places_key_values;
CREATE VIEW dssview.stopregistry_group_of_stop_places_members AS
    SELECT
        version,
        group_of_stop_places_id,
        ref
    FROM stopregistry.group_of_stop_places_members;
CREATE VIEW dssview.stopregistry_group_of_tariff_zones AS
    SELECT
        created,
        changed,
        private_code_value,
        id,
        description_lang,
        purpose_of_grouping_ref_version,
        netex_id,
        private_code_type,
        changed_by,
        version_comment,
        version,
        to_date,
        from_date,
        name_value,
        purpose_of_grouping_ref,
        description_value,
        name_lang
    FROM stopregistry.group_of_tariff_zones;
CREATE VIEW dssview.stopregistry_group_of_tariff_zones_key_values AS
    SELECT
        key_values_key,
        group_of_tariff_zones_id,
        key_values_id
    FROM stopregistry.group_of_tariff_zones_key_values;
CREATE VIEW dssview.stopregistry_group_of_tariff_zones_members AS
    SELECT
        ref,
        group_of_tariff_zones_id,
        version
    FROM stopregistry.group_of_tariff_zones_members;
CREATE VIEW dssview.stopregistry_hsl_accessibility_properties AS
    SELECT
        lower_cleat_height,
        to_date,
        accessibility_level,
        sidewalk_accessible_connection,
        stop_area_surroundings_accessible,
        version,
        curved_stop,
        stop_area_side_slope,
        stop_area_lengthwise_slope,
        netex_id,
        stop_elevation_from_sidewalk,
        version_comment,
        end_ramp_slope,
        shelter_lane_distance,
        curb_back_of_rail_distance,
        changed_by,
        service_area_stripes,
        guidance_stripe,
        guidance_tiles,
        stop_type,
        shelter_type,
        created,
        from_date,
        curb_drive_side_of_rail_distance,
        stop_elevation_from_rail_top,
        structure_lane_distance,
        guidance_type,
        map_type,
        id,
        platform_edge_warning_area,
        pedestrian_crossing_ramp_type,
        service_area_length,
        service_area_width,
        changed
    FROM stopregistry.hsl_accessibility_properties;
CREATE VIEW dssview.stopregistry_info_spot AS
    SELECT
        private_code_value,
        height,
        width,
        polygon_id,
        centroid,
        speech_property,
        backlight,
        version,
        to_date,
        from_date,
        created,
        changed,
        id,
        name_lang,
        purpose,
        description_value,
        description_lang,
        netex_id,
        private_code_type,
        maintenance,
        zone_label,
        rail_information,
        floor,
        display_type,
        info_spot_location,
        version_comment,
        changed_by,
        info_spot_type,
        label,
        name_value
    FROM stopregistry.info_spot;
CREATE VIEW dssview.stopregistry_info_spot_key_values AS
    SELECT
        key_values_key,
        key_values_id,
        info_spot_id
    FROM stopregistry.info_spot_key_values;
CREATE VIEW dssview.stopregistry_info_spot_location AS
    SELECT
        info_spot_id,
        location_netex_id
    FROM stopregistry.info_spot_location;
CREATE VIEW dssview.stopregistry_info_spot_poster AS
    SELECT
        changed,
        changed_by,
        label,
        lines,
        height,
        width,
        version,
        id,
        to_date,
        version_comment,
        netex_id,
        from_date,
        created
    FROM stopregistry.info_spot_poster;
CREATE VIEW dssview.stopregistry_info_spot_poster_key_values AS
    SELECT
        key_values_key,
        info_spot_poster_id,
        key_values_id
    FROM stopregistry.info_spot_poster_key_values;
CREATE VIEW dssview.stopregistry_info_spot_poster_ref AS
    SELECT
        info_spot_id,
        ref,
        version
    FROM stopregistry.info_spot_poster_ref;
CREATE VIEW dssview.stopregistry_installed_equipment AS
    SELECT
        id,
        equipment_id,
        item_type
    FROM stopregistry.installed_equipment;
CREATE VIEW dssview.stopregistry_installed_equipment_version_structure AS
    SELECT
        shelter_number,
        id,
        changed,
        created,
        from_date,
        to_date,
        version,
        out_of_service,
        number_of_machines,
        ticket_machines,
        ticket_office,
        cycle_storage_type,
        number_of_spaces,
        gender,
        number_of_toilets,
        height,
        height_from_floor,
        machine_readable,
        width,
        air_conditioned,
        heated,
        length,
        seats,
        smoking_allowed,
        step_free,
        wheelchair_area_length,
        wheelchair_area_width,
        enclosed,
        class_of_use_ref,
        women_only,
        number_of_frames,
        line_signage,
        replaces_rail_sign,
        main_line_sign,
        shelter_lighting,
        timetable_cabinets,
        trash_can,
        shelter_has_display,
        bicycle_parking,
        leaning_rail,
        outside_bench,
        shelter_fascia_board_taping,
        dtype,
        netex_id,
        version_comment,
        private_code_type,
        private_code_value,
        brand_graphic,
        sign_graphic,
        content_lang,
        content_value,
        sign_content_type,
        changed_by,
        note_value,
        note_lang,
        shelter_type,
        shelter_electricity,
        shelter_condition,
        shelter_external_id
    FROM stopregistry.installed_equipment_version_structure;
CREATE VIEW dssview.stopregistry_installed_equipment_version_structure_installed_equipment AS
    SELECT
        place_equipment_id,
        installed_equipment_id
    FROM stopregistry.installed_equipment_version_structure_installed_equipment;
CREATE VIEW dssview.stopregistry_level AS
    SELECT
        all_areas_wheelchair_accessible,
        version,
        to_date,
        from_date,
        created,
        changed_by,
        changed,
        id,
        description_id,
        name_id,
        short_name_id,
        netex_id,
        public_code,
        version_comment,
        public_use
    FROM stopregistry.level;
CREATE VIEW dssview.stopregistry_level_key_values AS
    SELECT
        key_values_key,
        level_id,
        key_values_id
    FROM stopregistry.level_key_values;
CREATE VIEW dssview.stopregistry_multilingual_string_entity AS
    SELECT
        value,
        id,
        lang
    FROM stopregistry.multilingual_string_entity;
CREATE VIEW dssview.stopregistry_navigation_path AS
    SELECT
        id,
        path_id,
        item_type
    FROM stopregistry.navigation_path;
CREATE VIEW dssview.stopregistry_organisation AS
    SELECT
        private_code,
        changed_by,
        contact_details_id,
        version_comment,
        netex_id,
        legal_name_lang,
        legal_name_value,
        organisation_type,
        name,
        company_number,
        private_contact_details_id,
        to_date,
        from_date,
        created,
        id,
        version,
        changed
    FROM stopregistry.organisation;
CREATE VIEW dssview.stopregistry_organisation_key_values AS
    SELECT
        key_values_id,
        key_values_key,
        organisation_id
    FROM stopregistry.organisation_key_values;
CREATE VIEW dssview.stopregistry_parking AS
    SELECT
        to_date,
        netex_id,
        version_comment,
        description_lang,
        description_value,
        name_lang,
        name_value,
        private_code_type,
        private_code_value,
        short_name_lang,
        short_name_value,
        parent_site_ref,
        parent_site_ref_version,
        booking_url,
        parking_type,
        changed_by,
        changed,
        created,
        id,
        from_date,
        version,
        centroid,
        all_areas_wheelchair_accessible,
        covered,
        free_parking_out_of_hours,
        number_of_parking_levels,
        overnight_parking_permitted,
        parking_layout,
        parking_reservation,
        principal_capacity,
        prohibited_for_hazardous_materials,
        real_time_occupancy_available,
        recharging_available,
        secure,
        total_capacity,
        polygon_id,
        accessibility_assessment_id,
        place_equipments_id,
        topographic_place_id
    FROM stopregistry.parking;
CREATE VIEW dssview.stopregistry_parking_adjacent_sites AS
    SELECT
        parking_id,
        ref,
        version
    FROM stopregistry.parking_adjacent_sites;
CREATE VIEW dssview.stopregistry_parking_alternative_names AS
    SELECT
        parking_id,
        alternative_names_id
    FROM stopregistry.parking_alternative_names;
CREATE VIEW dssview.stopregistry_parking_area AS
    SELECT
        covered,
        version,
        to_date,
        from_date,
        parking_properties_id,
        place_equipments_id,
        created,
        centroid,
        all_areas_wheelchair_accessible,
        changed,
        accessibility_assessment_id,
        id,
        level_ref,
        level_ref_version,
        site_ref,
        site_ref_version,
        changed_by,
        total_capacity,
        polygon_id,
        netex_id,
        version_comment,
        description_lang,
        description_value,
        name_lang,
        name_value,
        private_code_type,
        private_code_value,
        short_name_lang,
        short_name_value
    FROM stopregistry.parking_area;
CREATE VIEW dssview.stopregistry_parking_area_alternative_names AS
    SELECT
        alternative_names_id,
        parking_area_id
    FROM stopregistry.parking_area_alternative_names;
CREATE VIEW dssview.stopregistry_parking_area_check_constraints AS
    SELECT
        parking_area_id,
        check_constraints_id
    FROM stopregistry.parking_area_check_constraints;
CREATE VIEW dssview.stopregistry_parking_area_equipment_places AS
    SELECT
        parking_area_id,
        equipment_places_id
    FROM stopregistry.parking_area_equipment_places;
CREATE VIEW dssview.stopregistry_parking_area_key_values AS
    SELECT
        key_values_id,
        key_values_key,
        parking_area_id
    FROM stopregistry.parking_area_key_values;
CREATE VIEW dssview.stopregistry_parking_capacity AS
    SELECT
        parking_stay_type,
        changed,
        parking_user_type,
        parking_vehicle_type,
        created,
        number_of_spaces_with_recharge_point,
        from_date,
        changed_by,
        id,
        netex_id,
        version_comment,
        version,
        to_date,
        parent_ref,
        number_of_spaces
    FROM stopregistry.parking_capacity;
CREATE VIEW dssview.stopregistry_parking_equipment_places AS
    SELECT
        parking_id,
        equipment_places_id
    FROM stopregistry.parking_equipment_places;
CREATE VIEW dssview.stopregistry_parking_key_values AS
    SELECT
        key_values_key,
        key_values_id,
        parking_id
    FROM stopregistry.parking_key_values;
CREATE VIEW dssview.stopregistry_parking_parking_areas AS
    SELECT
        parking_areas_id,
        parking_id FROM stopregistry.parking_parking_areas;
CREATE VIEW dssview.stopregistry_parking_parking_payment_process AS
    SELECT
        parking_id,
        parking_payment_process FROM stopregistry.parking_parking_payment_process;
CREATE VIEW dssview.stopregistry_parking_parking_properties AS
    SELECT
        parking_properties_id,
        parking_id FROM stopregistry.parking_parking_properties;
CREATE VIEW dssview.stopregistry_parking_parking_vehicle_types AS
    SELECT
        parking_vehicle_types,
        parking_id FROM stopregistry.parking_parking_vehicle_types;
CREATE VIEW dssview.stopregistry_parking_properties AS
    SELECT
        from_date,
        to_date,
        version,
        changed_by,
        version_comment,
        netex_id,
        changed,
        created,
        id
    FROM stopregistry.parking_properties;
CREATE VIEW dssview.stopregistry_parking_properties_parking_user_types AS
    SELECT
        parking_user_types,
        parking_properties_id
    FROM stopregistry.parking_properties_parking_user_types;
CREATE VIEW dssview.stopregistry_parking_properties_spaces AS
    SELECT
        spaces_id,
        parking_properties_id
    FROM stopregistry.parking_properties_spaces;
CREATE VIEW dssview.stopregistry_path_junction AS
    SELECT
        changed,
        id,
        to_date,
        changed_by,
        from_date,
        created,
        netex_id,
        version_comment,
        version
    FROM stopregistry.path_junction;
CREATE VIEW dssview.stopregistry_path_junction_key_values AS
    SELECT
        key_values_key,
        path_junction_id,
        key_values_id 
    FROM stopregistry.path_junction_key_values;
CREATE VIEW dssview.stopregistry_path_link AS
    SELECT
        mobility_restricted_traveller_duration,
        occasional_traveller_duration,
        from_id,
        line_string,
        version,
        to_date,
        from_date,
        created,
        changed_by,
        version_comment,
        netex_id,
        changed,
        default_duration,
        id,
        to_id,
        frequent_traveller_duration
    FROM stopregistry.path_link;
CREATE VIEW dssview.stopregistry_path_link_end AS
    SELECT
        netex_id,
        place_ref,
        place_version,
        path_junction_id,
        id
    FROM stopregistry.path_link_end;
CREATE VIEW dssview.stopregistry_path_link_key_values AS
    SELECT
        key_values_id,
        key_values_key,
        path_link_id
    FROM stopregistry.path_link_key_values;
CREATE VIEW dssview.stopregistry_persistable_polygon AS
    SELECT
        id,
        polygon
    FROM stopregistry.persistable_polygon;
CREATE VIEW dssview.stopregistry_place_equipment AS
    SELECT
        length,
        smoking_allowed,
        step_free,
        wheelchair_area_length,
        wheelchair_area_width,
        enclosed,
        class_of_use_ref,
        women_only,
        number_of_frames,
        line_signage,
        replaces_rail_sign,
        main_line_sign,
        shelter_lighting,
        out_of_service,
        timetable_cabinets,
        version,
        to_date,
        from_date,
        created,
        changed,
        id,
        place_equipment_id,
        shelter_number,
        trash_can,
        shelter_has_display,
        bicycle_parking,
        leaning_rail,
        content_value,
        sign_content_type,
        changed_by,
        note_value,
        note_lang,
        shelter_type,
        shelter_electricity,
        shelter_condition,
        shelter_external_id,
        shelter_fascia_board_taping,
        outside_bench,
        dtype,
        netex_id,
        version_comment,
        private_code_type,
        private_code_value,
        brand_graphic,
        sign_graphic,
        content_lang,
        ticket_office,
        cycle_storage_type,
        number_of_spaces,
        gender,
        number_of_toilets,
        ticket_machines,
        height,
        height_from_floor,
        machine_readable,
        width,
        number_of_machines,
        air_conditioned,
        heated,
        seats
    FROM stopregistry.place_equipment;
CREATE VIEW dssview.stopregistry_purpose_of_grouping AS
    SELECT
        netex_id,
        changed,
        created,
        from_date,
        to_date,
        version,
        name_lang,
        description_value,
        description_lang,
        name_value,
        changed_by,
        version_comment,
        id 
    FROM stopregistry.purpose_of_grouping;
CREATE VIEW dssview.stopregistry_purpose_of_grouping_key_values AS
    SELECT
        key_values_key,
        purpose_of_grouping_id,
        key_values_id
    FROM stopregistry.purpose_of_grouping_key_values;
CREATE VIEW dssview.stopregistry_quay_alt_name_by_type AS
    SELECT
        name_lang,
        quay_id,
        name_type,
        name_value
    FROM stopregistry.quay_alt_name_by_type;
CREATE VIEW dssview.stopregistry_quay_alternative_names AS
    SELECT
        alternative_names_id,
        quay_id
    FROM stopregistry.quay_alternative_names;
CREATE VIEW dssview.stopregistry_quay_boarding_positions AS
    SELECT
        quay_id,
        boarding_positions_id
    FROM stopregistry.quay_boarding_positions;
CREATE VIEW dssview.stopregistry_quay_check_constraints AS
    SELECT
        quay_id,
        check_constraints_id
    FROM stopregistry.quay_check_constraints;
CREATE VIEW dssview.stopregistry_quay_equipment_places AS
    SELECT
        quay_id,
        equipment_places_id
    FROM stopregistry.quay_equipment_places;
CREATE VIEW dssview.stopregistry_quay_external_links AS
    SELECT
        name,
        order_num,
        quay_id,
        location
    FROM stopregistry.quay_external_links;
CREATE VIEW dssview.stopregistry_quay_key_values AS
    SELECT
        key_values_id,
        quay_id,
        key_values_key
    FROM stopregistry.quay_key_values;
CREATE VIEW dssview.stopregistry_quay_organisations AS
    SELECT
        relationship_type,
        organisation_ref,
        quay_id
    FROM stopregistry.quay_organisations;
CREATE VIEW dssview.stopregistry_stop_place_access_spaces AS
    SELECT
        stop_place_id,
        access_spaces_id
    FROM stopregistry.stop_place_access_spaces;
CREATE VIEW dssview.stopregistry_stop_place_adjacent_sites AS
    SELECT
        stop_place_id,
        version,
        ref
    FROM stopregistry.stop_place_adjacent_sites;
CREATE VIEW dssview.stopregistry_stop_place_alternative_names AS
    SELECT
        stop_place_id,
        alternative_names_id
    FROM stopregistry.stop_place_alternative_names;
CREATE VIEW dssview.stopregistry_stop_place_children AS
    SELECT
        children_id,
        stop_place_id
    FROM stopregistry.stop_place_children;
CREATE VIEW dssview.stopregistry_stop_place_equipment_places AS
    SELECT
        equipment_places_id,
        stop_place_id
    FROM stopregistry.stop_place_equipment_places;
CREATE VIEW dssview.stopregistry_stop_place_external_links AS
    SELECT
        stop_place_id,
        location,
        name,
        order_num
    FROM stopregistry.stop_place_external_links;
CREATE VIEW dssview.stopregistry_stop_place_key_values AS
    SELECT
        key_values_key,
        key_values_id,
        stop_place_id
    FROM stopregistry.stop_place_key_values;
CREATE VIEW dssview.stopregistry_stop_place_organisations AS
    SELECT
        stop_place_id,
        organisation_ref,
        relationship_type
    FROM stopregistry.stop_place_organisations;
CREATE VIEW dssview.stopregistry_stop_place_quays AS
    SELECT
        stop_place_id,
        quays_id
    FROM stopregistry.stop_place_quays;
CREATE VIEW dssview.stopregistry_stop_place_tariff_zones AS
    SELECT
        ref,
        stop_place_id,
        version
    FROM stopregistry.stop_place_tariff_zones;
CREATE VIEW dssview.stopregistry_tariff_zone AS
    SELECT
        centroid,
        polygon_id,
        id,
        changed,
        created,
        from_date,
        netex_id,
        version_comment,
        description_lang,
        description_value,
        name_lang,
        name_value,
        private_code_type,
        private_code_value,
        short_name_lang,
        short_name_value,
        changed_by,
        to_date,
        version
    FROM stopregistry.tariff_zone;
CREATE VIEW dssview.stopregistry_tariff_zone_key_values AS
    SELECT
        key_values_id,
        tariff_zone_id,
        key_values_key
    FROM stopregistry.tariff_zone_key_values;
CREATE VIEW dssview.stopregistry_topographic_place AS
    SELECT
        short_name_lang,
        private_code_value,
        description_lang,
        version_comment,
        netex_id,
        created,
        to_date,
        version,
        centroid,
        from_date,
        iso_code,
        country_ref,
        short_name_value,
        topographic_place_type,
        changed_by,
        id,
        changed,
        polygon_id,
        country_ref_value,
        private_code_type,
        name_value,
        name_lang,
        description_value,
        parent_ref,
        parent_ref_version
    FROM stopregistry.topographic_place;
CREATE VIEW dssview.stopregistry_topographic_place_key_values AS
    SELECT
        key_values_id,
        topographic_place_id,
        key_values_key
    FROM stopregistry.topographic_place_key_values;
CREATE VIEW dssview.stopregistry_value AS
    SELECT
        id
    FROM stopregistry.value;
CREATE VIEW dssview.stopregistry_value_items AS
    SELECT
        value_id,
        items
    FROM stopregistry.value_items;



-- Use view to display only the newest version of stop place
CREATE VIEW dssview.stopregistry_stop_place AS
    SELECT
       id,
       netex_id,
       changed,
       created,
       from_date,
       to_date,
       version,
       version_comment,
       description_lang,
       description_value,
       name_lang,
       name_value,
       private_code_type,
       private_code_value,
       short_name_lang,
       short_name_value,
       centroid,
       all_areas_wheelchair_accessible,
       covered,
       parent_site_ref,
       parent_site_ref_version,
       air_submode,
       border_crossing,
       bus_submode,
       coach_submode,
       funicular_submode,
       metro_submode,
       public_code,
       rail_submode,
       stop_place_type,
       telecabin_submode,
       tram_submode,
       transport_mode,
       water_submode,
       weighting,
       polygon_id,
       accessibility_assessment_id,
       place_equipments_id,
       topographic_place_id,
       changed_by,
       parent_stop_place,
       modification_enumeration,

       -- Extra location bits
       street_address,

       -- HSL validity info
       priority,
       validity_start,
       validity_end,

       -- Type booleans | Technically we just need a negated version of 'parent_stop_place'
       -- to do a proper join to Timat from the view, as by default stopPlace(id: ...)
       -- query returns the Parent Terminal instead of the normal child StopPlace, and
       -- to get the child with ID one needs to add onlyMonomodalStopPlaces: true to the query.
       is_terminal,
       is_area
    FROM stopregistry.stop_place_newest_version;

-- Use view to display only the newest version of quay
CREATE VIEW dssview.stopregistry_quay AS
    SELECT
       id,
       netex_id,
       changed,
       created,
       from_date,
       to_date,
       version,
       version_comment,
       description_lang,
       description_value,
       name_lang,
       name_value,
       private_code_type,
       private_code_value,
       short_name_lang,
       short_name_value,
       centroid,
       all_areas_wheelchair_accessible,
       covered,
       level_ref,
       level_ref_version,
       site_ref,
       site_ref_version,
       label_lang,
       label_value,
       compass_bearing,
       public_code,
       polygon_id,
       accessibility_assessment_id,
       place_equipments_id,
       changed_by,

       -- Extra location bits
       location_swe,
       street_address,

       -- HSL validity info
       priority,
       validity_start,
       validity_end,

       -- Extra used keyvalues
       ely_code,
       postal_code,
       functional_area,
       stop_state,
       stop_owner,
       timing_place_id,

       -- Stop Place info
       stop_place_id,
       stop_place_version,
       stop_place_netex_id
    FROM stopregistry.quay_newest_version q
    WHERE EXISTS (
      SELECT 1 FROM dssview.dssview.network_scheduled_stop_point ssp
      WHERE ssp.stop_place_ref = q.netex_id
    );
