Feature: Create a beer style

  In order to provide more information about a beer
  As an API client
  I want to be able to create beer styles via the API

  Background:
    Given the following user exists:
      | public_token | private_token |
      | a1b2c3       | x1y2z3        |

  Scenario: Creating a beer style with a private token
    When I create the following beer style via the API using the "x1y2z3" token:
      | name                   | description      |
      | Fruit / Vegetable Beer | Fruity and stuff |
    Then I should receive a 201 response
    And the Location header should be set to the API beer style page for "Fruit / Vegetable Beer"
    And the following beer style should exist:
      | user                  | name                   | description      |
      | private_token: x1y2z3 | Fruit / Vegetable Beer | Fruity and stuff |

  Scenario: Creating a beer style with a public token
    When I create the following beer style via the API using the "a1b2c3" token:
      | name                   | description      |
      | Fruit / Vegetable Beer | Fruity and stuff |
    Then I should receive a 401 response
    And the API user with the public token "a1b2c3" should have 0 beer styles

  Scenario: Creating a beer style with validation errors
    When I create the following beer style via the API using the "x1y2z3" token:
      | name                   |
      | Fruit / Vegetable Beer | 
    Then I should receive a 400 response
    And I should see the following JSON response:
      """
        { "errors" : {
            "description" : ["can't be blank"]
          }
        }
      """

  Scenario Outline:
    When I send an API POST request to /v1/beer_styles.<format>?token=<token>
      """
      <body>
      """
    Then I should receive a <status> response

  Examples:
    | body                                     | token  | status | format |
    | { "beer_style" : { "name" : "Porter" } } | a1b2c3 | 401    | json   |
    | { "beer_style" : {} }                    | a1b2c3 | 401    | json   |
    | {}                                       | a1b2c3 | 401    | json   |
    |                                          | a1b2c3 | 401    | json   |
    | { "beer_style" : { "name" : "Porter" } } | a1b2c3 | 401    | xml    |
    | { "beer_style" : {} }                    | x1y2z3 | 400    | json   |
    | {}                                       | x1y2z3 | 400    | json   |
    |                                          | x1y2z3 | 400    | json   |
    | { "beer_style" : { "name" : "Porter" } } | x1y2z3 | 406    | xml    |
    | { "beer_style" : { "name" : "Porter" } } |        | 401    | json   |
    | { "beer_style" : {} }                    |        | 401    | json   |
    | {}                                       |        | 401    | json   |
    |                                          |        | 401    | json   |
    | { "beer_style" : { "name" : "Porter" } } |        | 401    | xml    |
