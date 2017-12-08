package com.sirolf2009.telegram.btcbot.command

import java.util.Random

class CommandJoke extends Command {

	static val jokes = #[
		"I asked a hooker if she accepted bitcoin. She told me no because it goes up and down more than she does.",
		"How many miners does it take to change a light bulb?\nA Million.\nOne to change it and a million to verify it's on",
		"My GPU died recently, turned out I was mining before it was cool",
		"(╯°□°）╯︵ ┻━┻",
		"I tried to come up with BTC jokes, but I could only come up with XRP",
		"There once was a girl from Des Moines
Whose breasts were as fine as her loins.
\"I'll do tricks for dollars,
Make all my guys holler,
But I save my best stuff for Bitcoins!\"",
		"Why do Java devs wear glasses?
Because they can't C#",
		"Software is like sex, it's better when it's free.
- Linus Torvalds",
		"The best thing about a boolean is even if you are wrong, you are only off by a bit. ",
		"A good programmer is someone who always looks both ways before crossing a one-way street.
- Doug Linder",
		"Programming is like sex, one mistake and you'll have to support it for the rest of your life.
- Michael Sinz",
		"Programming today is a race between software engineers striving to build bigger and better idiot-proof programs, and the universe trying to produce bigger and better idiots. So far, the universe is winning.
- Rick Cook",
		"In order to understand recursion, one must first understand recursion",
		"VI has 2 modes. One that beeps at you, and another that ruins everything.",
		"Every program has at least one bug and can be shortened by at least one instruction - from which, by induction, it is evident that every program	can be reduced to one instruction that does not work.
- Ken Arnold"
	]
	static val rand = new Random()

	new() {
		super("joke", "", "Tell me a joke!") [
			return jokes.get(rand.nextInt(jokes.size()))
		]
	}

}
