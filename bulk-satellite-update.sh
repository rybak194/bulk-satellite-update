#!/bin/sh

bash update-root.bash pw.esn.pl esn_pw || echo -e "\e[31mUpdate failed\e[0m"
bash update-root.bash azure-test.esn.pl esn_azure || echo -e "\e[31mUpdate failed\e[0m"
bash update-root.bash pwr.esn.pl esn_pwr || echo -e "\e[31mUpdate failed\e[0m"
bash update-root.bash agh.esn.pl esn_agh || echo -e "\e[31mUpdate failed\e[0m"