# Godot Warrior

This fun little game teaches you basic programming skills using Godot! You don't need any prior knowledge in Godot or GDScript to get started, and the concepts learned here will apply to any programming language you want to pick up. If you're looking for more general learning resources, check out the section below.

You play as a warrior attempting to escape this mysterious tower. You start by writing a script that instructs your warrior to walk, and slowly gain more abilities that you can use to advance. Each floor contains some challenges your warrior (and you) will have to overcome. The goal is to give the warrior enough knowledge to make it through alive.

## Getting Started

1.  Download Godot from [https://godotengine.org/download](https://godotengine.org/download). This game uses version **3.5.1**, so make sure you select that option.
2.  Click on the **Use this template** button at the top of this repo to make a copy of the game in your own account, so that you can track changes. 
	1. If you don't have a Github account, you can select the "Code" button next to it and "Download ZIP".
3. Clone the repository to your computer by following [these instructions](https://docs.github.com/en/repositories/creating-and-managing-repositories/cloning-a-repository) or using the Github Desktop client.
4. Open up Godot and select "Import New". Select the folder you just unzipped or cloned.
5. Double click to open, and voila!

Once you've opened the project in Godot, you'll see the editor screen before you. The "Game" scene should be automatically opened, but if it isn't, double click on `game.tscn` in the "Filesystem" tab. Once there, you have two goals, (1) edit your player script to command your warrior, and (2) run the game and see how well you did:
<img width="1404" alt="Screenshot 2022-12-06 at 9 18 45 AM" src="https://user-images.githubusercontent.com/10522360/207465665-e5430dff-4182-438c-b98b-9c6807bbe8e5.png">


## The Script

```python
class_name Player
extends Node

func play_turn(warrior: Unit) -> void:
	# Put your code here.
```

Your objective is to apply basic programming skills to the  `play_turn` method with commands to instruct your warrior. With each level your abilities will grow along with the difficulty. Click on the "Abilities" button to see what abilities you have gained.

Here is a simple example to attack if you feel an enemy, or walk if you don't:
```python
func play_turn(warrior: Unit) -> void:
	if warrior.feel("enemy"):
		warrior.attack()
	else:
		warrior.walk()
```
Once you are done editing the player script, save the file and run the game with Godot using the play button in the top right of the editor. You will be running a debug version of the game, where you can watch your turn play out, and read helpful hints.

**Some notes:** Don't worry about failing a level. You should try to program your warrior so that they can pass each level, but if you die you'll be given some helpful tips to keep trying. Once you reach the stairs, check out what new abilities you have an try to apply them to win the stage.

Also, if you're just learning how to program, don't be discouraged! Either reach out for help, try again, or practice with one of the resources below.

## Abilities

Each level will unlock a new ability that will test how well you've set up the logic in your player script. Here is a summary of all of the abilities you unlock during the game:
```python
# Call to walk in a straight line.
warrior.walk()

# Call to determine whether the space in front of you is occupied. You can pass in options like "enemy" and "trap".
warrior.feel(String)

# Call to attack anything in the space next to you.
warrior.attack()

# Call to recover a portion of your health.
warrior.rest()

# Call to disarm traps and chests.
warrior.disarm()

# Call to get a list of spaces ahead of you.
warrior.look()

# Call to attack at range with your bow
warrior.shoot()

# Call to protect yourself from attacks.
warrior.defend()
```

### Special Thanks

- [Ruby Warrior](https://github.com/ryanb/ruby-warrior) - The inspiration for it all and a tremendous resource. I couldn't have done it without this amazing work.
- [GDQuest](https://www.gdquest.com/) - The underlying grid and unit movement was built from one of their tutorials. They have amazing resources and I highly recommend checking them out.
- [Kenney](https://kenney.nl/) - The best free game assets in the _world_. Check them out!

---

## Want to learn more?

Here's a little self-study guide I put together to help people new to programming get started. If you don’t have time for some of the extra steps, focusing on Step 2 should be enough.

#### Step 1: Familiarity
CodeCademy is my recommendation for building familiarity in any programming language, although it is not a great teaching tool because so much of it is done for you. Run through the Python3 course just to get used to the language, play around with some of the syntax, and learn to recognize some of the pieces. It’s kind of like pre-studying: gets you ready to really start to understand everything when you see it a second time.
[https://www.codecademy.com/catalog/language/python](https://www.codecademy.com/catalog/language/python)

#### Step 2: The Hard Way
This book is incredible and is what got me started on Python programming in 2010. It’s challenging, but not impossible, and well worth the money and time investment. He does an excellent job of getting you to work through everything so that you’re applying the knowledge. I highly recommend this as your main focus.
[https://learnpythonthehardway.org/python3/](https://learnpythonthehardway.org/python3/)

#### Step 3: The Lighthouse Way
This course from Lighthouse Labs just dropped and, while I’ve only taken a cursory glance at it, I feel like their resources and teaching are strong enough to recommend it. Lighthouse was definitely a big bump for my career path, so I think this would be a safe bet.
[https://lighthouse-labs.thinkific.com/courses/programming-essentials-with-python](https://lighthouse-labs.thinkific.com/courses/programming-essentials-with-python)

#### Step 4: Practice
The above resources should be enough to get you pretty proficient in Python. It will probably be a struggle for the first while, but when it clicks it’s the best feeling. A minimal amount of teaching resources are best supplemented with just lots and lots of practice (and many of the resources above have built-in practice exercises). Codewars is my favourite (see link below), but anything that interests you and has you practicing is good!
[https://www.codewars.com/](https://www.codewars.com/)
