namespace: Integrations.demo.aos.sub_flows
flow:
  name: deploy_wars
  inputs:
    - tomcat_host
    - account_service_host
    - db_host
    - username
    - password
    - url: "${get_sp('war_repo_root_url')}"
  results: []
