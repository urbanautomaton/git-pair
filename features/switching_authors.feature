Feature: Switching authors
  In order to indicate which authors are committing
  A user should be able to
  change the currently active pair

  Scenario: No authors have been added
    When I try to switch to the pair "AA BB"
    Then the last command's output should include "Please add some authors first"

  Scenario: Pairing with a single author
    Given I have added the author "Linus Torvalds <linus@example.org>"
    When I switch to the pair "LT"
    Then `git pair` should display "Linus Torvalds" for the current author
    And `git pair` should display "linus@example.org" for the current email

  Scenario: Pairing with two authors
    Given I have added the author "Linus Torvalds <linus@example.org>"
    And I have added the author "Junio C Hamano <junio@example.org>"
    And my global Git configuration is setup with email "devs@example.com"
    When I switch to the pair "LT JCH"
    Then `git pair` should display "Junio C Hamano + Linus Torvalds" for the current author
    And `git pair` should display "devs+jch+lt@example.com" for the current email

  Scenario: Pairing with two authors, specifyed by first names
    Given I have added the author "Linus Torvalds <linus@example.org>"
    And I have added the author "Junio C Hamano <junio@example.org>"
    And my global Git configuration is setup with email "devs@example.com"
    When I switch to the pair "linus junio"
    Then `git pair` should display "Junio C Hamano + Linus Torvalds" for the current author
    And `git pair` should display "devs+jch+lt@example.com" for the current email

  Scenario: Pairing with two authors, specifyed by last names
    Given I have added the author "Linus Torvalds <linus@example.org>"
    And I have added the author "Junio C Hamano <junio@example.org>"
    And my global Git configuration is setup with email "devs@example.com"
    When I switch to the pair "torvalds hamano"
    Then `git pair` should display "Junio C Hamano + Linus Torvalds" for the current author
    And `git pair` should display "devs+jch+lt@example.com" for the current email

