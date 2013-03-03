Feature: List beer styles

  In order to use the database in my application
  As an API client
  I want to be able to list beer styles

  Background:
    Given the following user exists:
      | public_token | private_token |
      | a1b2c3       | x1y2z3        |
    And the following beer styles exist:
      | id | user                  | name                           | description      | created_at           | updated_at           |
      | 1  |                       | Pumpkin Ale                    | Pumpkiny         | 2010-05-05T00:00:00Z | 2010-06-06T00:00:00Z |
      | 2  | private_token: x1y2z3 | American Double / Imperial IPA | Delicious ale    | 2010-05-05T00:00:00Z | 2010-06-06T00:00:00Z |
      | 3  |                       | Fruit / Vegetable Beer         | Fruity and stuff | 2010-05-05T00:00:00Z | 2010-06-06T00:00:00Z |
      | 4  | private_token: d1e2f3 | American Porter                | A lighter stout? | 2010-05-05T00:00:00Z | 2010-06-06T00:00:00Z |

  Scenario: Listing beer styles
    When I send an API GET request to /v1/beer_styles.json
    Then I should receive a 200 response
    And I should see the following JSON response:
      """
        { "page"  : 1,
          "pages" : 1,
          "total" : 2,
          "beer_styles" : [
            { "id"          : 1,
              "name"        : "Pumpkin Ale",
              "description" : "Pumpkiny",
              "created_at"  : "2010-05-05T00:00:00Z",
              "updated_at"  : "2010-06-06T00:00:00Z"
            },
            { "id"          : 3,
              "name"        : "Fruit / Vegetable Beer",
              "description" : "Fruity and stuff",
              "created_at"  : "2010-05-05T00:00:00Z",
              "updated_at"  : "2010-06-06T00:00:00Z"
            }
          ]
        }
      """

  Scenario: Listing beer styles with JSONP
    When I send an API GET request to /v1/beer_styles.json?callback=onBeerStylesLoad
    Then I should receive a 200 response
    And I should see the following JSONP response with an "onBeerStylesLoad" callback:
      """
        { "page"  : 1,
          "pages" : 1,
          "total" : 2,
          "beer_styles" : [
            { "id"          : 1,
              "name"        : "Pumpkin Ale",
              "description" : "Pumpkiny",
              "created_at"  : "2010-05-05T00:00:00Z",
              "updated_at"  : "2010-06-06T00:00:00Z"
            },
            { "id"          : 3,
              "name"        : "Fruit / Vegetable Beer",
              "description" : "Fruity and stuff",
              "created_at"  : "2010-05-05T00:00:00Z",
              "updated_at"  : "2010-06-06T00:00:00Z"
            }
          ]
        }
      """

  Scenario: Listing beer styles with pagination
    When I send an API GET request to /v1/beer_styles.json?page=2&per_page=1
    Then I should receive a 200 response
    And I should see the following JSON response:
      """
        { "page"  : 2,
          "pages" : 2,
          "total" : 2,
          "beer_styles" : [
            { "id"          : 3,
              "name"        : "Fruit / Vegetable Beer",
              "description" : "Fruity and stuff",
              "created_at"  : "2010-05-05T00:00:00Z",
              "updated_at"  : "2010-06-06T00:00:00Z"
            }
          ]
        }
      """

  Scenario: Listing beer styles with entries from an API client using a public token
    When I send an API GET request to /v1/beer_styles.json?token=a1b2c3
    Then I should receive a 200 response
    And I should see the following JSON response:
      """
        { "page"  : 1,
          "pages" : 1,
          "total" : 3,
          "beer_styles" : [
            { "id"          : 1,
              "name"        : "Pumpkin Ale",
              "description" : "Pumpkiny",
              "created_at"  : "2010-05-05T00:00:00Z",
              "updated_at"  : "2010-06-06T00:00:00Z"
            },
            { "id"          : 2,
              "name"        : "American Double / Imperial IPA",
              "description" : "Delicious ale",
              "created_at"  : "2010-05-05T00:00:00Z",
              "updated_at"  : "2010-06-06T00:00:00Z"
            },
            { "id"          : 3,
              "name"        : "Fruit / Vegetable Beer",
              "description" : "Fruity and stuff",
              "created_at"  : "2010-05-05T00:00:00Z",
              "updated_at"  : "2010-06-06T00:00:00Z"
            }
          ]
        }
      """

  Scenario: Listing beer styles with entries from an API client using a private token
    When I send an API GET request to /v1/beer_styles.json?token=x1y2z3
    Then I should receive a 200 response
    And I should see the following JSON response:
      """
        { "page"  : 1,
          "pages" : 1,
          "total" : 3,
          "beer_styles" : [
            { "id"          : 1,
              "name"        : "Pumpkin Ale",
              "description" : "Pumpkiny",
              "created_at"  : "2010-05-05T00:00:00Z",
              "updated_at"  : "2010-06-06T00:00:00Z"
            },
            { "id"          : 2,
              "name"        : "American Double / Imperial IPA",
              "description" : "Delicious ale",
              "created_at"  : "2010-05-05T00:00:00Z",
              "updated_at"  : "2010-06-06T00:00:00Z"
            },
            { "id"          : 3,
              "name"        : "Fruit / Vegetable Beer",
              "description" : "Fruity and stuff",
              "created_at"  : "2010-05-05T00:00:00Z",
              "updated_at"  : "2010-06-06T00:00:00Z"
            }
          ]
        }
      """

  Scenario: Listing beer styles with custom sorting
    When I send an API GET request to /v1/beer_styles.json?order=name%20asc
    Then I should receive a 200 response
    And I should see the following JSON response:
      """
        { "page"  : 1,
          "pages" : 1,
          "total" : 2,
          "beer_styles" : [
            { "id"          : 3,
              "name"        : "Fruit / Vegetable Beer",
              "description" : "Fruity and stuff",
              "created_at"  : "2010-05-05T00:00:00Z",
              "updated_at"  : "2010-06-06T00:00:00Z"
            },
            { "id"          : 1,
              "name"        : "Pumpkin Ale",
              "description" : "Pumpkiny",
              "created_at"  : "2010-05-05T00:00:00Z",
              "updated_at"  : "2010-06-06T00:00:00Z"
            }
          ]
        }
      """

  Scenario: Listing beer styles, with a search query
    When I send an API GET request to /v1/beer_styles.json?query=pump
    Then I should receive a 200 response
    And I should see the following JSON response:
      """
        { "page"  : 1,
          "pages" : 1,
          "total" : 1,
          "beer_styles" : [
            { "id"          : 1,
              "name"        : "Pumpkin Ale",
              "description" : "Pumpkiny",
              "created_at"  : "2010-05-05T00:00:00Z",
              "updated_at"  : "2010-06-06T00:00:00Z"
            }
          ]
        }
      """

  Scenario: Listing beer styles, with an invalid search query
    When I send an API GET request to /v1/beer_styles.json?query=a
    Then I should receive a 400 response

  Scenario: Listing beer styles in an invalid format
    When I send an API GET request to /v1/beer_styles.xml
    Then I should receive a 406 response
