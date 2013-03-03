Feature: List beers

  In order to use the database in my application
  As an API client
  I want to be able to list beers

  Background:
    Given the following user exists:
      | public_token | private_token |
      | a1b2c3       | x1y2z3        |
    And the following breweries exist:
      | id | name          |
      | 1  | Southern Tier |
      | 2  | Abita         |
      | 3  | Russian River |
    And the following beer styles exist:
      | id | name                           | description      |
      | 1  | Pumpkin Ale                    | Pumpkiny         | 
      | 2  | American Double / Imperial IPA | Delicious ale    |
      | 3  | Fruit / Vegetable Beer         | Fruity and stuff |
    And the following beers exist:
      | id | user                  | brewery             | beer_style                           | name               | description | abv | created_at | updated_at |
      | 1  |                       | name: Southern Tier | name: Pumpkin Ale                    | Pumpking           | Seasonal.   | 8.8 | 2010-01-01 | 2010-02-02 |
      | 2  | private_token: x1y2z3 | name: Russian River | name: American Double / Imperial IPA | Pliney the Elder   | Rare.       | 8.0 | 2010-03-03 | 2010-04-04 |
      | 3  |                       | name: Abita         | name: Fruit / Vegetable Beer         | Strawberry Harvest | Southern.   | 4.2 | 2010-05-05 | 2010-06-06 |
      | 4  | private_token: d1e2f3 | name: Russian River | name: American Double / Imperial IPA | Pliney the Younger | Rarer.      | 8.0 | 2010-07-07 | 2010-08-08 |

  Scenario: Listing beers
    When I send an API GET request to /v1/beers.json
    Then I should receive a 200 response
    And I should see the following JSON response:
      """
        { "page"  : 1,
          "pages" : 1,
          "total" : 2,
          "beers" : [
            { "id"          : 1,
              "name"        : "Pumpking",
              "description" : "Seasonal.",
              "abv"         : 8.8,
              "created_at"  : "2010-01-01T00:00:00Z",
              "updated_at"  : "2010-02-02T00:00:00Z",
              "brewery"     : {
                "id"   : 1,
                "name" : "Southern Tier"
              },
              "beer_style" : {
                "id"   : 1,
                "name" : "Pumpkin Ale"
              }
            },
            { "id"          : 3,
              "name"        : "Strawberry Harvest",
              "description" : "Southern.",
              "abv"         : 4.2,
              "created_at"  : "2010-05-05T00:00:00Z",
              "updated_at"  : "2010-06-06T00:00:00Z",
              "brewery"     : {
                "id"   : 2,
                "name" : "Abita"
              },
              "beer_style" : {
                "id"   : 3,
                "name" : "Fruit / Vegetable Beer"
              }
            }
          ]
        }
      """

  Scenario: Listing beers with JSONP
    When I send an API GET request to /v1/beers.json?callback=onBeersLoad
    Then I should receive a 200 response
    And I should see the following JSONP response with an "onBeersLoad" callback:
      """
        { "page"  : 1,
          "pages" : 1,
          "total" : 2,
          "beers" : [
            { "id"          : 1,
              "name"        : "Pumpking",
              "description" : "Seasonal.",
              "abv"         : 8.8,
              "created_at"  : "2010-01-01T00:00:00Z",
              "updated_at"  : "2010-02-02T00:00:00Z",
              "brewery"     : {
                "id"   : 1,
                "name" : "Southern Tier"
              },
              "beer_style" : {
                "id"   : 1,
                "name" : "Pumpkin Ale"
              }
            },
            { "id"          : 3,
              "name"        : "Strawberry Harvest",
              "description" : "Southern.",
              "abv"         : 4.2,
              "created_at"  : "2010-05-05T00:00:00Z",
              "updated_at"  : "2010-06-06T00:00:00Z",
              "brewery"     : {
                "id"   : 2,
                "name" : "Abita"
              },
              "beer_style" : {
                "id"   : 3,
                "name" : "Fruit / Vegetable Beer"
              }
            }
          ]
        }
      """

  Scenario: Listing beers with pagination
    When I send an API GET request to /v1/beers.json?page=2&per_page=1
    Then I should receive a 200 response
    And I should see the following JSON response:
      """
        { "page"  : 2,
          "pages" : 2,
          "total" : 2,
          "beers" : [
            { "id"          : 3,
              "name"        : "Strawberry Harvest",
              "description" : "Southern.",
              "abv"         : 4.2,
              "created_at"  : "2010-05-05T00:00:00Z",
              "updated_at"  : "2010-06-06T00:00:00Z",
              "brewery"     : {
                "id"   : 2,
                "name" : "Abita"
              },
              "beer_style" : {
                "id"   : 3,
                "name" : "Fruit / Vegetable Beer"
              }
            }
          ]
        }
      """

  Scenario: Listing beers with entries from an API client using a public token
    When I send an API GET request to /v1/beers.json?token=a1b2c3
    Then I should receive a 200 response
    And I should see the following JSON response:
      """
        { "page"  : 1,
          "pages" : 1,
          "total" : 3,
          "beers" : [
            { "id"          : 1,
              "name"        : "Pumpking",
              "description" : "Seasonal.",
              "abv"         : 8.8,
              "created_at"  : "2010-01-01T00:00:00Z",
              "updated_at"  : "2010-02-02T00:00:00Z",
              "brewery"     : {
                "id"   : 1,
                "name" : "Southern Tier"
              },
              "beer_style" : {
                "id"   : 1,
                "name" : "Pumpkin Ale"
              }
            },
            { "id"          : 2,
              "name"        : "Pliney the Elder",
              "description" : "Rare.",
              "abv"         : 8.0,
              "created_at"  : "2010-03-03T00:00:00Z",
              "updated_at"  : "2010-04-04T00:00:00Z",
              "brewery"     : {
                "id"   : 3,
                "name" : "Russian River"
              },
              "beer_style" : {
                "id"   : 2,
                "name" : "American Double / Imperial IPA"
              }
            },
            { "id"          : 3,
              "name"        : "Strawberry Harvest",
              "description" : "Southern.",
              "abv"         : 4.2,
              "created_at"  : "2010-05-05T00:00:00Z",
              "updated_at"  : "2010-06-06T00:00:00Z",
              "brewery"     : {
                "id"   : 2,
                "name" : "Abita"
              },
              "beer_style" : {
                "id"   : 3,
                "name" : "Fruit / Vegetable Beer"
              }
            }
          ]
        }
      """

  Scenario: Listing beers with entries from an API client using a private token
    When I send an API GET request to /v1/beers.json?token=x1y2z3
    Then I should receive a 200 response
    And I should see the following JSON response:
      """
        { "page"  : 1,
          "pages" : 1,
          "total" : 3,
          "beers" : [
            { "id"          : 1,
              "name"        : "Pumpking",
              "description" : "Seasonal.",
              "abv"         : 8.8,
              "created_at"  : "2010-01-01T00:00:00Z",
              "updated_at"  : "2010-02-02T00:00:00Z",
              "brewery"     : {
                "id"   : 1,
                "name" : "Southern Tier"
              },
              "beer_style" : {
                "id"   : 1,
                "name" : "Pumpkin Ale"
              }
            },
            { "id"          : 2,
              "name"        : "Pliney the Elder",
              "description" : "Rare.",
              "abv"         : 8.0,
              "created_at"  : "2010-03-03T00:00:00Z",
              "updated_at"  : "2010-04-04T00:00:00Z",
              "brewery"     : {
                "id"   : 3,
                "name" : "Russian River"
              },
              "beer_style" : {
                "id"   : 2,
                "name" : "American Double / Imperial IPA"
              }
            },
            { "id"          : 3,
              "name"        : "Strawberry Harvest",
              "description" : "Southern.",
              "abv"         : 4.2,
              "created_at"  : "2010-05-05T00:00:00Z",
              "updated_at"  : "2010-06-06T00:00:00Z",
              "brewery"     : {
                "id"   : 2,
                "name" : "Abita"
              },
              "beer_style" : {
                "id"   : 3,
                "name" : "Fruit / Vegetable Beer"
              }
            }
          ]
        }
      """

  Scenario: Listing beers with custom sorting
    When I send an API GET request to /v1/beers.json?order=updated_at%20desc
    Then I should receive a 200 response
    And I should see the following JSON response:
      """
        { "page"  : 1,
          "pages" : 1,
          "total" : 2,
          "beers" : [
            { "id"          : 3,
              "name"        : "Strawberry Harvest",
              "description" : "Southern.",
              "abv"         : 4.2,
              "created_at"  : "2010-05-05T00:00:00Z",
              "updated_at"  : "2010-06-06T00:00:00Z",
              "brewery"     : {
                "id"   : 2,
                "name" : "Abita"
              },
              "beer_style" : {
                "id"   : 3,
                "name" : "Fruit / Vegetable Beer"
              }
            },
            { "id"          : 1,
              "name"        : "Pumpking",
              "description" : "Seasonal.",
              "abv"         : 8.8,
              "created_at"  : "2010-01-01T00:00:00Z",
              "updated_at"  : "2010-02-02T00:00:00Z",
              "brewery"     : {
                "id"   : 1,
                "name" : "Southern Tier"
              },
              "beer_style" : {
                "id"   : 1,
                "name" : "Pumpkin Ale"
              }
            }
          ]
        }
      """

  Scenario: Listing beers, with a search query
    When I send an API GET request to /v1/beers.json?query=berry
    Then I should receive a 200 response
    And I should see the following JSON response:
      """
        { "page"  : 1,
          "pages" : 1,
          "total" : 1,
          "beers" : [
            { "id"          : 3,
              "name"        : "Strawberry Harvest",
              "description" : "Southern.",
              "abv"         : 4.2,
              "created_at"  : "2010-05-05T00:00:00Z",
              "updated_at"  : "2010-06-06T00:00:00Z",
              "brewery"     : {
                "id"   : 2,
                "name" : "Abita"
              },
              "beer_style" : {
                "id"   : 3,
                "name" : "Fruit / Vegetable Beer"
              }
            }
          ]
        }
      """

  Scenario: Listing beers, for a specific brewery
    When I send an API GET request to /v1/beers.json?brewery_id=2
    Then I should receive a 200 response
    And I should see the following JSON response:
      """
        { "page"  : 1,
          "pages" : 1,
          "total" : 1,
          "beers" : [
            { "id"          : 3,
              "name"        : "Strawberry Harvest",
              "description" : "Southern.",
              "abv"         : 4.2,
              "created_at"  : "2010-05-05T00:00:00Z",
              "updated_at"  : "2010-06-06T00:00:00Z",
              "brewery"     : {
                "id"   : 2,
                "name" : "Abita"
              },
              "beer_style" : {
                "id"   : 3,
                "name" : "Fruit / Vegetable Beer"
              }
            }
          ]
        }
      """

  Scenario: Listing beers, with an invalid search query
    When I send an API GET request to /v1/beers.json?query=a
    Then I should receive a 400 response

  Scenario: Listing beers in an invalid format
    When I send an API GET request to /v1/beers.xml
    Then I should receive a 406 response
