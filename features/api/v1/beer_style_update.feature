Feature: Update a beer style

  In order to change beer style information
  As an API client
  I want to be able to update beer style via the API

  Background:
    Given the following user exists:
      | public_token | private_token |
      | a1b2c3       | x1y2z3        |

  Scenario: Updating a beer style with a private token
    Given the following beer style exists:
      | id | user                  | name                   | description      |
      | 1  | private_token: x1y2z3 | Fruit / Vegetable Beer | Fruity and stuff |
    When I update the "Fruit / Vegetable Beer" beer style via the API using the "x1y2z3" token:
      | description  |
      | Ultra fruity |
    Then I should receive a 200 response
    And the following beer style should exist:
      | user                  | name                   | description  |
      | private_token: x1y2z3 | Fruit / Vegetable Beer | Ultra fruity |

  Scenario: Updating a beer style with a public token
    Given the following beer style exists:
      | id | user                 | name                   | description      |
      | 1  | public_token: a1b2c3 | Fruit / Vegetable Beer | Fruity and stuff |
    When I update the "Fruit / Vegetable Beer" beer style via the API using the "a1b2c3" token:
      | description  |
      | Ultra fruity |
    Then I should receive a 401 response
    And the following beer style should exist:
      | user                 | name                   | description      |
      | public_token: a1b2c3 | Fruit / Vegetable Beer | Fruity and stuff |

  Scenario: Updating a beer style not owned by the requesting API client as an administrator
     Given the following beer style exists:
      | id | user                  | name                   | description      |
      | 1  | private_token: x1y2z3 | Fruit / Vegetable Beer | Fruity and stuff |
    And the following user exists:
      | private_token | administrator |
      | e1f2g3        | true          |
    When I update the "Fruit / Vegetable Beer" beer style via the API using the "e1f2g3" token:
      | description  |
      | Ultra fruity |
    Then I should receive a 200 response
    And the following beer style should exist:
      | user                  | name                   | description  |
      | private_token: x1y2z3 | Fruit / Vegetable Beer | Ultra fruity |

  Scenario: Updating a beer style not owned by the requesting API client
    Given the following beer style exists:
      | id | user                  | name                   | description      |
      | 1  | private_token: d4e5f6 | Fruit / Vegetable Beer | Fruity and stuff |
    When I update the "Fruit / Vegetable Beer" beer style via the API using the "a1b2c3" token:
      | description  |
      | Ultra fruity |
    Then I should receive a 401 response
    And the following beer style should exist:
      | user                  | name                   | description      |
      | private_token: d4e5f6 | Fruit / Vegetable Beer | Fruity and stuff |

  Scenario: Updating a beer style not owned by an API client
    Given the following beer style exists:
      | id | name                   | description      |
      | 1  | Fruit / Vegetable Beer | Fruity and stuff |
    When I update the "Fruit / Vegetable Beer" beer style via the API using the "a1b2c3" token:
      | description  |
      | Ultra fruity |
    Then I should receive a 401 response
    And the following beer style should exist:
      | name                   | description      |
      | Fruit / Vegetable Beer | Fruity and stuff |

  Scenario: Updating a beer style not owned by an API client as an administrator
    Given the following beer style exists:
      | id | name                   | description      |
      | 1  | Fruit / Vegetable Beer | Fruity and stuff |
    And the following user exists:
      | private_token | administrator |
      | e1f2g3        | true          |
    When I update the "Fruit / Vegetable Beer" beer style via the API using the "e1f2g3" token:
      | description  |
      | Ultra fruity |
    Then I should receive a 200 response
    And the following beer style should exist:
      | name                   | description  |
      | Fruit / Vegetable Beer | Ultra fruity |

  Scenario: Updating a beer style with validation errors
    Given the following beer style exists:
      | id | user                  | name                   | description      |
      | 1  | private_token: x1y2z3 | Fruit / Vegetable Beer | Fruity and stuff |
    When I update the "Fruit / Vegetable Beer" beer style via the API using the "x1y2z3" token:
      | description |
      |             |
    Then I should receive a 400 response
    And I should see the following JSON response:
      """
        { "errors" : {
            "description" : ["can't be blank"]
          }
        }
      """

  Scenario: Updating a beer style that does not exist
    When I send an API PUT request to /v1/beer_styles/1.json?token=x1y2z3
    Then I should receive a 404 response

  Scenario: Updating a beer style without an API token
    When I send an API PUT request to /v1/beer_styles/1.json
    Then I should receive a 401 response
