List<Map<String, dynamic>> expensesIncomesPaymentType(String code) {
  switch (code) {
    case 'pt':
      return [
        {"value": "Expense", "label": "Despesa"},
        {"value": "Income", "label": "Receita"},
      ];

    case 'en':
      return [
        {"value": "Expense", "label": "Expense"},
        {"value": "Income", "label": "Income"},
      ];

    default:
      return [];
  }
}

Map<String, dynamic> expensesIncomesCategory(String code) {
  switch (code) {
    case 'pt':
      return {
        "Expense": {
          {"value": "Employees", "label": "Funcionarios"},
          {"value": "Fuels", "label": "Combustiveis e Oleos"},
          {
            "value": "Equipment maintenance",
            "label": "Manutenção de equipamentos"
          },
          {
            "value": "Equipment acquisition",
            "label": "Aquisição de equipamentos"
          }
        },
        "Income": {
          {"value": "Cleaning", "label": "Serviço de limpeza"},
          {"value": "Pruning", "label": "Serviço de poda"}
        },
      };

    case 'en':
      return {
        "Expense": {
          {"value": "Employees", "label": "Employees"},
          {"value": "Fuels", "label": "Fuels"},
          {"value": "Equipment maintenance", "label": "Equipment maintenance"},
          {"value": "Equipment acquisition", "label": "Equipment acquisition"}
        },
        "Income": {
          {"value": "Cleaning", "label": "Cleaning"},
          {"value": "Pruning", "label": "Pruning"}
        },
      };

    default:
      return {};
  }
}
