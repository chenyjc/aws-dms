# !/bin/bash
script=$(readlink -f "$0")
script_path=$(dirname "$script")

mkdir -p $script_path/json

task_id=full-customer-service-prod-messages-history
cat << EOF > $script_path/json/${task_id}_table.json
{
  "rules": [
    {
      "rule-type": "selection",
      "rule-id": "1",
      "rule-name": "1",
      "object-locator": {
        "schema-name": "customer_service_prod",
        "table-name": "messages_history"
      },
      "rule-action": "include"
    }
  ]
}
EOF

task_id=full-asc-weixin-mp-menu-click-his
cat << EOF > $script_path/json/${task_id}_table.json
{
  "rules": [
    {
      "rule-type": "selection",
      "rule-id": "1",
      "rule-name": "1",
      "object-locator": {
        "schema-name": "asc_weixin_mp",
        "table-name": "menu_click_his"
      },
      "rule-action": "include"
    }
  ]
}
EOF

task_id=full-cdc-csswechat
cat << EOF > $script_path/json/${task_id}_table.json
{
  "rules": [
    {
      "rule-type": "selection",
      "rule-id": "1",
      "rule-name": "1",
      "object-locator": {
        "schema-name": "customer_service_prod",
        "table-name": "customer_service_worker"
      },
      "rule-action": "include"
    },
    {
      "rule-type": "selection",
      "rule-id": "2",
      "rule-name": "2",
      "object-locator": {
        "schema-name": "customer_service_prod",
        "table-name": "caseinfo"
      },
      "rule-action": "include"
    },
    {
      "rule-type": "selection",
      "rule-id": "3",
      "rule-name": "3",
      "object-locator": {
        "schema-name": "customer_service_prod",
        "table-name": "sessiontime"
      },
      "rule-action": "include"
    },
    {
      "rule-type": "selection",
      "rule-id": "4",
      "rule-name": "4",
      "object-locator": {
        "schema-name": "customer_service_prod",
        "table-name": "system_account"
      },
      "rule-action": "include"
    },
    {
      "rule-type": "selection",
      "rule-id": "50",
      "rule-name": "50",
      "object-locator": {
        "schema-name": "asc_weixin_mp",
        "table-name": "satisfaction_survey"
      },
      "rule-action": "include"
    },
    {
      "rule-type": "selection",
      "rule-id": "51",
      "rule-name": "51",
      "object-locator": {
        "schema-name": "asc_weixin_mp",
        "table-name": "customer"
      },
      "rule-action": "include"
    },
    {
      "rule-type": "selection",
      "rule-id": "52",
      "rule-name": "52",
      "object-locator": {
        "schema-name": "asc_weixin_mp",
        "table-name": "alias_desc"
      },
      "rule-action": "include"
    },
    {
      "rule-type": "selection",
      "rule-id": "54",
      "rule-name": "54",
      "object-locator": {
        "schema-name": "asc_weixin_mp",
        "table-name": "customer_product"
      },
      "rule-action": "include"
    },
    {
      "rule-type": "selection",
      "rule-id": "101",
      "rule-name": "101",
      "object-locator": {
        "schema-name": "asc_weixin_mp",
        "table-name": "menu_click_his"
      },
      "rule-action": "include",
      "filters": [
        {
          "filter-type": "source",
          "column-name": "id",
          "filter-conditions": [
            {
              "filter-operator": "gte",
              "value": "20113835"
            }
          ]
        }
      ]
    },    
    {
      "rule-type": "selection",
      "rule-id": "102",
      "rule-name": "102",
      "object-locator": {
        "schema-name": "customer_service_prod",
        "table-name": "messages_history"
      },
      "rule-action": "include",
      "filters": [
        {
          "filter-type": "source",
          "column-name": "MSG_ID",
          "filter-conditions": [
            {
              "filter-operator": "gte",
              "value": "37756171"
            }
          ]
        }
      ]
    }
  ]
}
EOF


ls -l  $script_path/json
