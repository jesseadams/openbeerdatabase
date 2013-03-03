Feature: View a beer style

  In order to see details on a beer style
  As an API client
  I want to be able to view a beer style

  Scenario: Viewing a beer style
    Given the following beer styles exist:
      | id | name        | description | created_at           | updated_at           |
      | 1  | Pumpkin Ale | Pumpkiny    | 2010-05-05T00:00:00Z | 2010-06-06T00:00:00Z |
    When I send an API GET request to /v1/beer_styles/1.json
    Then I should receive a 200 response
    And I should see the following JSON response:
      """
        { "id"         : 1,
          "name"       : "Pumpkin Ale",
          "description": "Pumpkiny", 
          "created_at" : "2010-05-05T00:00:00Z",
          "updated_at" : "2010-06-06T00:00:00Z"
        }
      """

  Scenario: Viewing a beer style with JSONP
    Given the following beer styles exist:
      | id | name        | description | created_at           | updated_at           |
      | 1  | Pumpkin Ale | Pumpkiny    | 2010-05-05T00:00:00Z | 2010-06-06T00:00:00Z |
    When I send an API GET request to /v1/beer_styles/1.json?callback=onBeerStyle
    Then I should receive a 200 response
    And I should see the following JSONP response with an "onBeerStyle" callback:
      """
        { "id"         : 1,
          "name"       : "Pumpkin Ale",
          "description": "Pumpkiny", 
          "created_at" : "2010-05-05T00:00:00Z",
          "updated_at" : "2010-06-06T00:00:00Z"
        }
      """

  Scenario: Viewing a public beer style using a private token
    Given the following user exists:
      | private_token |
      | x1y2z3        |
    And the following beer style exists:
      | id | user | name        | description | created_at           | updated_at           |
      | 1  |      | Pumpkin Ale | Pumpkiny    | 2010-05-05T00:00:00Z | 2010-06-06T00:00:00Z |
    When I send an API GET request to /v1/beer_styles/1.json?token=x1y2z3
    Then I should receive a 200 response
    And I should see the following JSON response:
      """
        { "id"         : 1,
          "name"       : "Pumpkin Ale",
          "description": "Pumpkiny", 
          "created_at" : "2010-05-05T00:00:00Z",
          "updated_at" : "2010-06-06T00:00:00Z"
        }
      """

  Scenario: Viewing a beer style from an API client using a public token
    Given the following beer style exists:
      | id | user                 | name        | description | created_at           | updated_at           |
      | 1  | public_token: a1b2c3 | Pumpkin Ale | Pumpkiny    | 2010-05-05T00:00:00Z | 2010-06-06T00:00:00Z |
    When I send an API GET request to /v1/beer_styles/1.json?token=a1b2c3
    Then I should receive a 200 response
    And I should see the following JSON response:
      """
        { "id"         : 1,
          "name"       : "Pumpkin Ale",
          "description": "Pumpkiny", 
          "created_at" : "2010-05-05T00:00:00Z",
          "updated_at" : "2010-06-06T00:00:00Z"
        }
      """

  Scenario: Viewing a beer style from an API client using a private token
    Given the following beer style exists:
      | id | user                  | name        | description | created_at           | updated_at           |
      | 1  | private_token: x1y2z3 | Pumpkin Ale | Pumpkiny    | 2010-05-05T00:00:00Z | 2010-06-06T00:00:00Z |
    When I send an API GET request to /v1/beer_styles/1.json?token=x1y2z3
    Then I should receive a 200 response
    And I should see the following JSON response:
      """
        { "id"         : 1,
          "name"       : "Pumpkin Ale",
          "description": "Pumpkiny", 
          "created_at" : "2010-05-05T00:00:00Z",
          "updated_at" : "2010-06-06T00:00:00Z"
        }
      """

  Scenario: Viewing a beer style not owned by the requesting API client as an administrator
    Given the following beer style exists:
      | id | user                  | name        | description      | created_at           | updated_at           |
      | 1  | private_token: x1y2z3 | Pumpkin Ale | Pumpkiny         | 2010-05-05T00:00:00Z | 2010-06-06T00:00:00Z |
    And the following user exists:
      | private_token | administrator |
      | e1f2g3        | true          |
    When I send an API GET request to /v1/beer_styles/1.json?token=e1f2g3
    Then I should receive a 200 response
    And I should see the following JSON response:
      """
        { "id"         : 1,
          "name"       : "Pumpkin Ale",
          "description": "Pumpkiny", 
          "created_at" : "2010-05-05T00:00:00Z",
          "updated_at" : "2010-06-06T00:00:00Z"
        }
      """

  Scenario: Viewing a beer style not owned by the requesting API client
    Given the following beer style exists:
      | id | user                 | name        | description      | created_at           | updated_at           |
      | 1  | public_token: a1b2c3 | Pumpkin Ale | Pumpkiny         | 2010-05-05T00:00:00Z | 2010-06-06T00:00:00Z |
    When I send an API GET request to /v1/beer_styles/1.json?token=d4e5f6
    Then I should receive a 401 response

  Scenario: Viewing a beer_style that does not exist
    When I send an API GET request to /v1/beer_styles/1.json
    Then I should receive a 404 response

  Scenario: Viewing a beer_style in an invalid format
    Given the following beer style exists:
      | id |
      | 1  |
    When I send an API GET request to /v1/beer_styles/1.xml
    Then I should receive a 406 response
