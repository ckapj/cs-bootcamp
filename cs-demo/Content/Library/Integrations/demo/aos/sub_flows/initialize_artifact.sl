namespace: Integrations.demo.aos.sub_flows
flow:
  name: initialize_artifact
  inputs:
    - host: 10.0.46.62
    - username: root
    - password: admin@123
    - artifact_url:
        required: false
    - script_url: 'http://vmdocker.hcm.demo.local:36980/job/AOS-repo/ws/deploy_war.sh'
    - parameters:
        required: false
  workflow:
    - Is_artifact_given:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${artifact_url}'
        navigate:
          - SUCCESS: copy_script
          - FAILURE: copy_artifact
    - copy_artifact:
        do:
          Integrations.demo.aos.sub_flows.remote_copy: []
        publish:
          - artifact_name: '${filename}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: copy_script
    - copy_script:
        do:
          Integrations.demo.aos.sub_flows.remote_copy: []
        publish:
          - script_name: '${filename}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: execute_script
    - execute_script:
        do:
          io.cloudslang.base.ssh.ssh_command:
            - host: '${host}'
            - command: "${'cd '+get_sp('script_location')+' && chmod 755 '+script_name+' && sh '+script_name+' '+get('artifact_name', '')+' '+get('parameters', '')+' > '+script_name+'.log'}"
            - username: '${username}'
            - password:
                value: '${password}'
                sensitive: true
        publish:
          - command_return_code
        navigate:
          - SUCCESS: delete_script
          - FAILURE: delete_script
    - delete_script:
        do:
          Integrations.demo.aos.tools.delete_file: []
        navigate:
          - SUCCESS: has_failed
          - FAILURE: on_failure
    - has_failed:
        do:
          io.cloudslang.base.utils.is_true:
            - bool_value: "${str(command_return_code == '0')}"
        navigate:
          - 'TRUE': SUCCESS
          - 'FALSE': FAILURE
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      Is_artifact_given:
        x: 301
        y: 53
      copy_artifact:
        x: 81
        y: 204
      copy_script:
        x: 475
        y: 216
      delete_script:
        x: 405
        y: 394
      execute_script:
        x: 86
        y: 392
      has_failed:
        x: 658
        y: 403
        navigate:
          7861dc71-7624-28b1-4e8b-0fcadfe3a739:
            targetId: a3955450-3258-e806-ed79-815d95cb8831
            port: 'TRUE'
          0bd147fa-57b4-efe8-a227-762e514d76eb:
            targetId: 906db8b1-3a46-e564-d375-e2cb7ef952e7
            port: 'FALSE'
    results:
      SUCCESS:
        a3955450-3258-e806-ed79-815d95cb8831:
          x: 754
          y: 328
      FAILURE:
        906db8b1-3a46-e564-d375-e2cb7ef952e7:
          x: 746
          y: 504
