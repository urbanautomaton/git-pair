Feature: Configuring address style
  In order to control the address of the committing email
  A user should be able to
  change the address style settings

  Scenario: Pairing with two authors
    Given I have added the author "Linus Torvalds <linus@example.org>"
    And I have added the author "Junio C Hamano <junio@example.org>"
    And my global Git configuration is setup with email "devs@example.com"
    When I switch to the pair "LT JCH"
    Then `git pair` should display "Junio C Hamano + Linus Torvalds" for the current author
    And `git pair` should display "devs+jch+lt@example.com" for the current email

  Scenario: Pairing with email pattern configured to use names
    Given I have added the author "Linus Torvalds <linus@example.org>"
    And I have added the author "Junio C Hamano <junio@example.org>"
    And my global Git configuration is setup with email "devs@example.com"
    And I add the email configuration pattern "foo+%name+%name@test.com"
    When I switch to the pair "LT JCH"
    Then `git pair` should display "Junio C Hamano + Linus Torvalds" for the current author
    And `git pair` should display "foo+junio+linus@test.com" for the current email

  Scenario: Pairing with email pattern set to use global domain
    Given I have added the author "Linus Torvalds <linus@example.org>"
    And I have added the author "Junio C Hamano <junio@example.org>"
    And my global Git configuration is setup with email "devs@test.com"
    And I add the email configuration pattern "devs+%abbr+%abbr@%domain"
    When I switch to the pair "LT JCH"
    Then `git pair` should display "Junio C Hamano + Linus Torvalds" for the current author
    And `git pair` should display "devs+jch+lt@test.com" for the current email

  Scenario: Pairing with email pattern set to use abbreviations
    Given I have added the author "Linus Torvalds <linus@example.org>"
    And I have added the author "Junio C Hamano <junio@example.org>"
    And my global Git configuration is setup with email "devs@example.com"
    And I add the email configuration pattern "developers+%abbr+%abbr@test.com"
    When I switch to the pair "LT JCH"
    Then `git pair` should display "Junio C Hamano + Linus Torvalds" for the current author
    And `git pair` should display "developers+jch+lt@test.com" for the current email
