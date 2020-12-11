CLASS zcl_jira_client DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .
  PUBLIC SECTION.

    INTERFACES zif_jira_client.

    METHODS constructor
      IMPORTING config TYPE zif_jira_client~jira_config.

  PROTECTED SECTION.
  PRIVATE SECTION.

    DATA client TYPE REF TO if_http_client.

    METHODS interpet_protocol
      IMPORTING protocol                    TYPE string
      RETURNING VALUE(interpreted_protocol) TYPE i.

ENDCLASS.

CLASS zcl_jira_client IMPLEMENTATION.
  METHOD constructor.

    cl_http_client=>create(
     EXPORTING
       host    = config-host
       service = config-port
       scheme  = me->interpet_protocol( config-protocol )
     IMPORTING
       client = me->client
     EXCEPTIONS
       OTHERS = 4 ).
    IF sy-subrc <> 0.
      RETURN.
    ENDIF.

    me->client->authenticate(
        EXPORTING
          username             = config-username
          password             = config-passwort
     ).
  ENDMETHOD.

  METHOD zif_jira_client~find_issue.
    DATA(client) = me->client.

    cl_http_utility=>set_request_uri( request = client->request
                                      uri     = zif_jira_client=>jira_routes-issue && issue_key ).

    client->request->set_method( 'GET' ).
    client->request->set_cdata( '' ).
    client->request->set_content_type( content_type = 'application/json;charset=UTF-8' ).

    client->send(
      EXCEPTIONS
        OTHERS = 4 ).
    IF sy-subrc <> 0.
      client->get_last_error(
        IMPORTING message = DATA(smsg) ).
      cl_demo_output=>display( smsg ).
      RETURN.
    ENDIF.

    client->receive(
      EXCEPTIONS
        OTHERS = 4 ).
    IF sy-subrc <> 0.
      client->get_last_error(
        IMPORTING message = DATA(rmsg) ).
      cl_demo_output=>display( rmsg ).
      RETURN.
    ENDIF.
    issue = client->response->get_cdata( ).
  ENDMETHOD.

  METHOD zif_jira_client~update_issue.
    DATA(client) = me->client.

    cl_http_utility=>set_request_uri( request = client->request
                                      uri     = zif_jira_client=>jira_routes-issue && issue_key ).

    client->request->set_method( 'PUT' ).
    client->request->set_cdata( issue_json ).
    client->request->set_content_type( content_type = 'application/json;charset=UTF-8' ).

    client->send(
    EXCEPTIONS
      OTHERS = 4 ).
    IF sy-subrc <> 0.
      client->get_last_error(
        IMPORTING message = DATA(smsg2) ).
      cl_demo_output=>display( smsg2 ).
      RETURN.
    ENDIF.

    client->receive(
   EXCEPTIONS
     OTHERS = 4 ).
    IF sy-subrc <> 0.
      client->get_last_error(
        IMPORTING message = DATA(rmsg2) ).
      cl_demo_output=>display( rmsg2 ).
      RETURN.
    ENDIF.

    client->response->get_status(
      IMPORTING
        code   = DATA(code)
        reason = DATA(reason)
    ).

    DATA(response) = client->response->get_cdata( ).

  ENDMETHOD.

  METHOD interpet_protocol.
    CASE protocol.
      WHEN 'http'.
        interpreted_protocol = 1.
      WHEN 'https'.
        interpreted_protocol = 2.
      WHEN OTHERS.
        interpreted_protocol = 1.
    ENDCASE.
  ENDMETHOD.


ENDCLASS.
