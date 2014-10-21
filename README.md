aws-list
========

This is ruby script for getting aws ec2 list.

* First, you install aws-sdk
```
 gem i aws-sdk --no-ri --no-rdoc -V
```

* Second, you configure the setting
```
vim config.yaml
~~ write your infomation of AWS ~~
```

* Third, you run aws_list.rb script. And you get below information.
  * EC2 instances
  * EIPs
  * AMIs
  * Volumes
  * Snapshots
