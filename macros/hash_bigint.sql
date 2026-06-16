{% macro hash_bigint(columns) -%}
    (
        CONVERT(
            BIGINT,
            SUBSTRING(
                HASHBYTES(
                    'SHA2_256',
                    CONCAT(
                        {%- for column in columns %}
                            COALESCE(CONVERT(VARCHAR(4000), {{ column }}), '__dbt_null__')
                            {%- if not loop.last %}, '||', {% endif -%}
                        {%- endfor %}
                    )
                ),
                1,
                8
            )
        ) & CAST(9223372036854775807 AS BIGINT)
    )
{%- endmacro %}
