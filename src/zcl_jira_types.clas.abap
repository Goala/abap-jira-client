CLASS zcl_jira_types DEFINITION PUBLIC FINAL.
  PUBLIC SECTION.

    TYPES: BEGIN OF ty_issue_fields,
             summary TYPE string,
           END OF ty_issue_fields,

           BEGIN OF ty_issue,
             id     TYPE string,
             key    TYPE string,
             fields TYPE ty_issue_fields,
           END OF ty_issue.

ENDCLASS.

CLASS zcl_jira_types IMPLEMENTATION.
ENDCLASS.
