 

## Zombie Exercise

## The Challenge

Create a fully-working API that allows to perform the following operations:

1. Create Zombies. Each zombie can have weapons and armors;
2. Update a Zombie's attributes, including (but not limited to) weapons and armors;
4. Search Zombies according to their attributes, weapons and armors;
3. Destroy a Zombie;
5. Make your API public. Deploy it using the service of your choice (e.g. AWS, Heroku, Digital Ocean...);
6. Create a Readme file including a short explanation of your technical choices and (if you wish) ideas and suggestions.

Too easy? Great, we think so too!

**Happy coding!**

### Some Observations - What was executed by me.

* In real life, I don't make funny test descriptions, but since we are talking about zombies,
I decided to do this with some humor... 

* I did pagination

* When submitting a zombie you can create a new weapon or armor with **weapons_attributes: %i[id name _destroy]**. I know this is strange, but it is a sample to add a new object with ```has_many``` related with zombie, but I blocked the update of the weapon name that way. I think you guys wanted me to add or remove a weapon/armor for a zombie like this: **weapon_ids: [].**
* I did some tasks related to [JSON:API](https://jsonapi.org/), but I commented it out. I explain why on ```config/initializers/ams.rb```
* I did some extra methods for searching with parameters too.You can check some examples on ```spec/queries/find_zombies_spec.rb```

* Although it was not mentioned, I did few validations on models to show some friendly errors. 

* I did some custom modules inside of the folder ```app/models/concerns/util```
* To make friendly errors, I created the module ```ErrorSerializer``` on file ```app/serializers/api/v1/error_serializer.rb```. 
* Tests are in folder spec
* I did some documentation on Postman:
   * On *Postman app* go to ```Import``` and then click ```Import from link ```
   * Use this link: https://www.getpostman.com/collections/be8d4bf7fec33b21d5d1

![postman](https://res.cloudinary.com/doht9u7kb/image/upload/v1548279523/Screen_Shot_2019-01-23_at_22.37.27_jmm7tf.png)

You can also access it on the web by using this link: https://web.postman.co/collections/1128603-9fbdf7c8-cb5e-4864-1812-8d3f264ae877?workspace=6c8f896b-97c9-4689-8c63-f35f044ce2d7

![image documentation](https://res.cloudinary.com/doht9u7kb/image/upload/v1548279734/Screen_Shot_2019-01-23_at_22.41.54_rsedsr.png)

* Any questions? Send me a message and I will try to help :D

* [Production url - heroku](https://whispering-ridge-50732.herokuapp.com/api/v1/zombies)

* To check manual search without gem is on the branch **manual_search**