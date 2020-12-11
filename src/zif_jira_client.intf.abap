INTERFACE zif_jira_client
  PUBLIC .

  CONSTANTS: BEGIN OF jira_routes,
               issue TYPE string VALUE '/rest/api/2/issue/',
             END OF jira_routes.

  TYPES: BEGIN OF jira_config,
           host     TYPE string,
           port     TYPE string,
           protocol TYPE string,
           username TYPE string,
           passwort TYPE string,
         END OF jira_config.

  METHODS find_issue
    IMPORTING issue_key    TYPE string
    RETURNING VALUE(issue) TYPE string.

  METHODS update_issue
    IMPORTING issue_key  TYPE string
              issue_json TYPE string.

ENDINTERFACE.
