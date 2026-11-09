{% macro drop_dev_schemas() %}

  {% if target.name == 'prod' %}
    {{ exceptions.raise_compiler_error("Refusing to drop schemas on the prod target") }}
  {% endif %}

  {% set prefix = target.schema | lower %}
  {{ log(" * drop_dev_schemas: looking in " ~ target.database ~ " for '" ~ prefix ~ "' and '" ~ prefix ~ "_*'", info=True) }}

  {% if execute %}
    {% set results = run_query(
      "SELECT schema_name FROM information_schema.schemata
       WHERE catalog_name = '" ~ target.database ~ "'
         AND (lower(schema_name) = '" ~ prefix ~ "'
              OR lower(schema_name) LIKE '" ~ prefix ~ "\_%' ESCAPE '\\')"
    ) %}
    {% set schemas = results.columns[0].values() %}

    {% if schemas | length == 0 %}
      {{ log(" * drop_dev_schemas: nothing to drop", info=True) }}
    {% else %}
      {% for schema in schemas %}
        {{ log(" * drop_dev_schemas: dropping " ~ target.database ~ "." ~ schema, info=True) }}
        {% do run_query("DROP SCHEMA IF EXISTS " ~ target.database ~ ".\"" ~ schema ~ "\" CASCADE") %}
      {% endfor %}
    {% endif %}
  {% endif %}

{% endmacro %}