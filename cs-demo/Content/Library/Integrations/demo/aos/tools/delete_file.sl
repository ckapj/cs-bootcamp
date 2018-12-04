namespace: Integrations.demo.aos.tools
flow:
  name: delete_file
  inputs:
    - host: 10.0.46.62
    - username: root
    - password: admin@123
    - filename: deploy_war.sh
  workflow:
    - delete_file:
        do:
          io.cloudslang.base.ssh.ssh_command:
            - host: '${host}'
            - command: "${'cd '+get_sp('script_location')+' && rm -f '+filename}"
            - username: '${username}'
            - password:
                value: '${password}'
                sensitive: true
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      delete_file:
        x: 213
        y: 94
        navigate:
          8b06da86-3596-0472-e0f3-1138b817704d:
            targetId: 04211e4f-ee81-7774-01cf-5010e3978cd4
            port: SUCCESS
    results:
      SUCCESS:
        04211e4f-ee81-7774-01cf-5010e3978cd4:
          x: 470
          y: 83
