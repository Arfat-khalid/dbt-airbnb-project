{% macro generate_schema_name(custom_schema_name, node) -%}
  {%- set custom_schema_name_cleansed = (custom_schema_name or '') | trim | lower -%}
  {%- set target_schema_cleansed = target.schema | trim | lower -%}

  {%- if custom_schema_name is none -%}
    {{ target_schema_cleansed }}
  {%- elif target.name == 'prod' -%}
    {{ custom_schema_name_cleansed }}
  {%- else -%}
    {{ target_schema_cleansed }}_{{ custom_schema_name_cleansed }}
  {%- endif -%}
{%- endmacro %}