Feature: Delete a beer style

  In order to remove unwanted beer styles
  As an API client
  I want to be able to delete beer styles via the API

  Background:
    Given the following user exists:
      | public_token | private_token |
      | a1b2c3       | x1y2z3        |

  Scenario: Deleting a beer style with a private token
    Given the following beer style exists:
      | user                  | id | name                   | description      |
      | private_token: x1y2z3 | 1  | Fruit / Vegetable Beer | Fruity and stuff |
    When I send an API DELETE request to /v1/beer_styles/1?token=x1y2z3
    Then I should receive a 200 response
    And the API user with the private token "x1y2z3" should have 0 beer styles

  Scenario: Deleting a beer style with a public token
    Given the following beer style exists:
      | user                 | id | name                   | description      |
      | public_token: a1b2c3 | 1  | Fruit / Vegetable Beer | Fruity and stuff |
    When I send an API DELETE request to /v1/beer_styles/1?token=a1b2c3
    Then I should receive a 401 response
    And the API user with the public token "a1b2c3" should have 1 beer style

  Scenario: Deleting a beer style not owned by the requesting API client as an administrator
    Given the following beer style exists:
      | user                  | id | name                   | description      |
      | private_token: x1y2z3 | 1  | Fruit / Vegetable Beer | Fruity and stuff |
    And the following user exists:
      | private_token | administrator |
      | e1f2g3        | true          |
    When I send an API DELETE request to /v1/beer_styles/1?token=e1f2g3
    Then I should receive a 200 response
    And the API user with the private token "x1y2z3" should have 0 beer styles

  Scenario: Deleting a beer style not owned by the requesting API client
    Given the following beer style exists:
      | user                  | id | name                   | description      |
      | private_token: d4e5f6 | 1  | Fruit / Vegetable Beer | Fruity and stuff |
    When I send an API DELETE request to /v1/beer_styles/1?token=a1b2c3
    Then I should receive a 401 response
    And the API user with the private token "d4e5f6" should have 1 beer style

  Scenario: Deleting a beer style not owned by an API client
    Given the following beer style exists:
      | id | name                   | description      |
      | 1  | Fruit / Vegetable Beer | Fruity and stuff |
    When I send an API DELETE request to /v1/beer_styles/1?token=a1b2c3
    Then I should receive a 401 response
    And the following beer style should exist:
      | id | name                   | description      |
      | 1  | Fruit / Vegetable Beer | Fruity and stuff |

  Scenario: Deleting a beer style with beers
    Given the following brewery exists:
      | id | user                  |
      | 1  | private_token: x1y2z3 |
    And the following beer style exists:
      | user                  | id | name                   | description      |
      | private_token: x1y2z3 | 1  | Fruit / Vegetable Beer | Fruity and stuff |
    And the following beer exists:
      | brewery     | beer_style                   | user                  |
      | name: Abita | name: Fruit / Vegetable Beer | private_token: x1y2z3 |
    When I send an API DELETE request to /v1/beer_styles/1?token=x1y2z3
    Then I should receive a 400 response
    And the API user with the private token "x1y2z3" should have 1 beer
    And the API user with the private token "x1y2z3" should have 1 beer style

  Scenario: Deleting a brewery that does not exist
    When I send an API DELETE request to /v1/breweries/1.json?token=x1y2z3
    Then I should receive a 404 response

  Scenario: Deleting a brewery without an API token
    When I send an API DELETE request to /v1/breweries/1.json
    Then I should receive a 401 response
