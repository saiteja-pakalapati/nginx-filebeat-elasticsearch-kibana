## **nginx-filebeat-elasticsearch-kibana**

---

A quick setup based on nginx,filebeat,elasticsearch and kibana.filebeat is used to parse the logs of nginx and stores in elasticsearch. This setup contains a basic dashboard showing different metrics for nginx

* Access nginx from [http://localhost:9000](http://localhost:9000)

* Access nginx metrics dashboard in kibana from [http://localhost:5601/app/kibana#/dashboard/144be580-543c-11e9-93a6-b75c1f1a0bc2](http://localhost:5601/app/kibana#/dashboard/144be580-543c-11e9-93a6-b75c1f1a0bc2)


 **Quick Start:**

 *  Requires [docker](https://docs.docker.com/install/) to be installed in the host 

 * clone this repository
    ```
    $ git clone git@github.com:saiteja-pakalapati/nginx-filebeat-elasticsearch-kibana.git
    $ cd nginx-filebeat-elasticsearch-kibana
    $ bash create.sh
    ```

 **Deleting the setup:**

   ```
    $ bash delete.sh
   ```
   
 **Displaying the help text:**
   
   display help text for create script
   ```
    $ bash create.sh --help
   ```
   
   display help text for delete script
   ```
    $ bash delete.sh --help
   ```
