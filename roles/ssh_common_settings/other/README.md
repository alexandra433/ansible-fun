Trying out this:
https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_variables.html#tips-on-where-to-set-variables

---
Variables set in one role are available to later roles. You can set variables in the role’s vars directory (as defined in Role directory structure) and use them in other roles and elsewhere in your playbook:

roles:
   - role: common_settings
   - role: something
     vars:
       foo: 12
   - role: something_else
---