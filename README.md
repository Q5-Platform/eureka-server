## Eureka Service on Cloud Foundry

This manual shows how to deploy and use Eureka Service on Cloud Foundry.

### Deploy Eureka Service to CF

    $ mvn clean package
    $ cf push blog-eureka -p target/eureka-server.jar -m 350m --no-start
    $ cf set-env blog-eureka SECURITY_USER_PASSWORD <eureka password>
    $ cf start blog-eureka
    $ cf apps
    Getting apps in org maki-org / space development as ***...
    OK

    name                       requested state   instances   memory   disk   urls
    blog-eureka                started           1/1         350M     1G     blog-eureka.cfapps.io

## Expose Eureka Service as a [User-Provided Service](https://docs.cloudfoundry.org/devguide/services/user-provided.html)


    $ cf create-user-provided-service eureka-service -p '{"uri":"https://eureka:<eureka password>@blog-eureka.cfapps.io.cfapps.io"}'
    $ cf services
    Getting services in org maki-org / space development as admin...
    OK

    name             service         plan   bound apps   last operation
    eureka-service   user-provided

## Bind Eureka Service to an application

    $ cf push foo -p target/foo.jar --no-start
    $ cf bind-service foo eureka-service

Discovery client services (like `foo`) should have the following property in `application.property`

    eureka.client.service-url.defaultZone=${vcap.services.eureka-service.credentials.uri:http://localhost:8761}/eureka/

and in `application-cloud.properties`

    eureka.instance.hostname=${vcap.application.uris[0]}
    eureka.instance.non-secure-port=80
    eureka.instance.metadata-map.instanceId=${vcap.application.instance_id}
