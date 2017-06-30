require 'telegram/bot'
class SortingHat
	QUESTIONS_SELECTIONS = {
		1 => [:dawn_dusk, :forest_river, :moon_stars],
		2 => [:hate_called, :after_death, :known_history, :potion],
		3 => [:goblets, :instrument, :magical_garden, :boxes],
		4 => [:difficult_deal, :troll, :would_rather_be],
		5 => [:power, :look_forward_learn, :most_like_study],
		6 => [:bridge, :cheating, :muggle, :nightmare, :road, :street],
		7 => [:pet],
		8 => [:black_white, :heads_tails, :left_right]
	}

	QUESTIONS_DETAILED = {
		:dawn_dusk => ['Dawn or dusk?', ['Dawn', 'Dusk']],
		:forest_river => ['Forest or river?', ['Forest', 'River']],
		:moon_stars => ['Moon or stars?', ['Moon', 'Stars']],
		:hate_called => ['Which of the following would you most hate people to call you?', ['Ordinary', 'Ignorant', 'Cowardly', 'Selfish']],
		:after_death => ['After you have died, what would you most like people to do when they hear your name?', ['Miss you, but smile', 'Ask for more stories about your adventures', 'Think with admiration of your achievements', 'I don\'t care what people think of me after I\'m dead; it\'s what they think of me while I\'m alive that counts']],
		:known_history => ['How would you like to be known to history?', ['The Wise', 'The Good', 'The Great', 'The Bold']],
		:potion => ['Given the choice, would you rather invent a potion that would guarantee you:', ['Love?', 'Glory?', 'Wisdom?', 'Power?']],
		:goblets => ['Four goblets are placed before you. Which would you choose to drink?', ['The foaming, frothing, silvery liquid that sparkles as though containing ground diamonds.', 'The smooth, thick, richly purple drink that gives off a delicious smell of chocolate and plums.', 'The golden liquid so bright that it hurts the eye, and which makes sunspots dance all around the room.', 'The mysterious black liquid that gleams like ink, and gives off fumes that make you see strange visions.']],
		:instrument => ['What kind of instrument most pleases your ear?', ['The violin', 'The trumpet', 'The piano', 'The drum']],
		:magical_garden => ['You enter an enchanted garden. What would you be most curious to examine first?', ['The silver leafed tree bearing golden apples', 'The fat red toadstools that appear to be talking to each other', 'The bubbling pool, in the depths of which something luminous is swirling', 'The statue of an old wizard with a strangely twinkling eye']],
		:boxes => ['Four boxes are placed before you. Which would you try and open?', ['The small tortoiseshell box, embellished with gold, inside which some small creature seems to be squeaking.', 'The gleaming jet black box with a silver lock and key, marked with a mysterious rune that you know to be the mark of Merlin.', 'The ornate golden casket, standing on clawed feet, whose inscription warns that both secret knowledge and unbearable temptation lie within.', 'The small pewter box, unassuming and plain, with a scratched message upon it that reads ‘I open only for the worthy.’']],
		:difficult_deal => ['Which of the following do you find most difficult to deal with?', ['Hunger', 'Cold', 'Loneliness', 'Boredom', 'Being ignored']],
		:troll => ['A troll has gone berserk in the Headmaster’s study at Hogwarts. It is about to smash, crush and tear several irreplaceable items and treasures. In which order would you rescue these objects from the troll’s club, if you could?', ['First, a nearly perfected cure for dragon pox. Then student records going back 1000 years. Finally, a mysterious handwritten book full of strange runes.', 'First, student records going back 1000 years. Then a mysterious handwritten book full of strange runes. Finally, a nearly perfected cure for dragon pox.', 'First, a mysterious handwritten book full of strange runes. Then a nearly perfected cure for dragon pox. Finally, student records going back 1000 years.', 'First, a nearly perfected cure for dragon pox. Then a mysterious handwritten book full of strange runes. Finally, student records going back 1000 years.', 'First student records going back 1000 years. Then, a nearly perfected cure for dragon pox. Finally, a mysterious handwritten book full of strange runes.', 'First, a mysterious handwritten book full of strange runes. Then student records going back 1000 years. Finally, a nearly perfected cure for dragon pox.']],
		:would_rather_be => ['Which would you rather be:', ['Envied?', 'Imitated?', 'Trusted?', 'Praised?', 'Liked?', 'Feared?']],
		:power => ['If you could have any power, which would you choose?', ['The power to read minds', 'The power of invisibility', 'The power of superhuman strength', 'The power to speak to animals', 'The power to change the past', 'The power to change your appearance at will']],
		:look_forward_learn => ['What are you most looking forward to learning at Hogwarts?', ['Apparition and Disapparition (being able to materialize and dematerialize at will)', 'Transfiguration (turning one object into another object)', 'Flying on a broomstick', 'Hexes and jinxes', 'All about magical creatures, and how to befriend/care for them', 'Secrets about the castle', 'Every area of magic I can']],
		:most_like_study => ['Which of the following would you most like to study?', ['Centaurs', 'Goblins', 'Merpeople', 'Ghosts', 'Vampires', 'Werewolves', 'Trolls']],
		:bridge => ['You and two friends need to cross a bridge guarded by a river troll who insists on fighting one of you before he will let all of you pass. Do you:', ['Attempt to confuse the troll into letting all three of you pass without fighting?', 'Suggest drawing lots to decide which of you will fight?', 'Suggest that all three of you should fight (without telling the troll)?', 'Volunteer to fight?']],
		:cheating => ['One of your house mates has cheated in a Hogwarts exam by using a Self-Spelling Quill. Now he has come top of the class in Charms, beating you into second place. Professor Flitwick is suspicious of what happened. He draws you to one side after his lesson and asks you whether or not your classmate used a forbidden quill. What do you do?', ['Lie and say you don’t know (but hope that somebody else tells Professor Flitwick the truth).', 'Tell Professor Flitwick that he ought to ask your classmate (and resolve to tell your classmate that if he doesn’t tell the truth, you will).', 'Tell Professor Flitwick the truth. If your classmate is prepared to win by cheating, he deserves to be found out. Also, as you are both in the same house, any points he loses will be regained by you, for coming first in his place.', 'You would not wait to be asked to tell Professor Flitwick the truth. If you knew that somebody was using a forbidden quill, you would tell the teacher before the exam started.']],
		:muggle => ['A Muggle confronts you and says that they are sure you are a witch or wizard. Do you:', ['Ask what makes them think so?', 'Agree, and ask whether they’d like a free sample of a jinx?', 'Agree, and walk away, leaving them to wonder whether you are bluffing?', 'Tell them that you are worried about their mental health, and offer to call a doctor.']],
		:nightmare => ['Which nightmare would frighten you most?', ['Standing on top of something very high and realizing suddenly that there are no hand- or footholds, nor any barrier to stop you falling.', 'An eye at the keyhole of the dark, windowless room in which you are locked.', 'Waking up to find that neither your friends nor your family have any idea who you are.', 'Being forced to speak in such a silly voice that hardly anyone can understand you, and everyone laughs at you.']],
		:road => ['Which road tempts you most?', ['The wide, sunny, grassy lane', 'The narrow, dark, lantern-lit alley', 'The twisting, leaf-strewn path through woods', 'The cobbled street lined with ancient buildings']],
		:street => ['Late at night, walking alone down the street, you hear a peculiar cry that you believe to have a magical source. Do you:', ['Proceed with caution, keeping one hand on your concealed wand and an eye out for any disturbance?', 'Draw your wand and try to discover the source of the noise?', 'Draw your wand and stand your ground?', 'Withdraw into the shadows to await developments, while mentally reviewing the most appropriate defensive and offensive spells, should trouble occur?']],
		:pet => ['If you were attending Hogwarts, which pet would you choose to take with you?', ['Tabby cat', 'Siamese cat', 'Ginger cat', 'Black cat', 'White cat', 'Tawny owl', 'Screech owl', 'Brown owl', 'Snowy owl', 'Barn owl', 'Common toad', 'Natterjack toad', 'Dragon toad', 'Harlequin toad', 'Three toed tree toad']],
		:black_white => ['Black or White?', ['Black', 'White']],
		:heads_tails => ['Heads or Tails', ['Heads', 'Tails']],
		:left_right => ['Left or Right', ['Left', 'Right']]
	}

	QUESTION_CHANCES = {
		:dawn_dusk => {
			'Dawn' => {g: 1, r: 1},
			'Dusk' => {h: 1, s: 1}
		},
		:forest_river => {
			'Forest' => {g: 1, r: 1},
			'River' => {h: 1, s: 1}
		},
		:moon_stars => {
			'Moon' => {r: 1, s: 1},
			'Stars' => {g: 1, h: 1}
		},
		:hate_called => {
			'Ordinary' => {s: 1},
			'Ignorant' => {r: 1},
			'Cowardly' => {g: 1},
			'Selfish'  => {h: 1}
		},
		:after_death => {
			'Miss you, but smile' => {h: 1},
			'Ask for more stories about your adventures' => {g: 1},
			'Think with admiration of your achievements' => {r: 1},
			'I don\'t care what people think of me after I\'m dead; it\'s what they think of me while I\'m alive that counts' => {s: 1}
		},
		:known_history => {
			'The Wise' => {r: 1},
			'The Good' => {h: 1},
			'The Great' => {s: 1},
			'The Bold' => {g: 1}
		},
		:potion => {
			'Love?' => {h: 1},
			'Glory?' => {g: 1},
			'Wisdom?' => {r: 1},
			'Power?' => {s: 1}
		},
		:goblets => {
			'The foaming, frothing, silvery liquid that sparkles as though containing ground diamonds.' => {r: 1},
			'The smooth, thick, richly purple drink that gives off a delicious smell of chocolate and plums.' => {h: 1},
			'The golden liquid so bright that it hurts the eye, and which makes sunspots dance all around the room.' => {g: 1},
			'The mysterious black liquid that gleams like ink, and gives off fumes that make you see strange visions.' => {s: 1}
		},
		:instrument => {
			'The violin' => {s: 1},
			'The trumpet' => {h: 1},
			'The piano' => {r: 1},
			'The drum' => {g: 1}
		},
		:magical_garden => {
			'The silver leafed tree bearing golden apples' => {r: 1},
			'The fat red toadstools that appear to be talking to each other' => {h: 1},
			'The bubbling pool, in the depths of which something luminous is swirling' => {s: 1},
			'The statue of an old wizard with a strangely twinkling eye' => {g: 1}
		},
		:boxes => {
			'The small tortoiseshell box, embellished with gold, inside which some small creature seems to be squeaking.' => {h: 1},
			'The gleaming jet black box with a silver lock and key, marked with a mysterious rune that you know to be the mark of Merlin.' => {s: 1},
			'The ornate golden casket, standing on clawed feet, whose inscription warns that both secret knowledge and unbearable temptation lie within.' => {r: 1},
			'The small pewter box, unassuming and plain, with a scratched message upon it that reads ‘I open only for the worthy.’' => {g: 1}
		},
		:difficult_deal => {
			'Hunger' => {r: 2, h: 2},
			'Cold' => {h: 2, s: 2},
			'Loneliness' => {g: 3, h: 1},
			'Boredom' => {g: 3, s: 1},
			'Being ignored' => {r: 3, s: 1}
		},
		:troll => {
			'First, a nearly perfected cure for dragon pox. Then student records going back 1000 years. Finally, a mysterious handwritten book full of strange runes.' => {g: 1, h: 1},
			'First, student records going back 1000 years. Then a mysterious handwritten book full of strange runes. Finally, a nearly perfected cure for dragon pox.' => {s: 1},
			'First, a mysterious handwritten book full of strange runes. Then a nearly perfected cure for dragon pox. Finally, student records going back 1000 years.' => {r: 1},
			'First, a nearly perfected cure for dragon pox. Then a mysterious handwritten book full of strange runes. Finally, student records going back 1000 years.' => {g: 1},
			'First student records going back 1000 years. Then, a nearly perfected cure for dragon pox. Finally, a mysterious handwritten book full of strange runes.' => {h: 1},
			'First, a mysterious handwritten book full of strange runes. Then student records going back 1000 years. Finally, a nearly perfected cure for dragon pox.' => {r: 1, s: 1}
		},
		:would_rather_be => {
			'Envied?' => {r: 1, s: 1},
			'Imitated?' => {r: 2},
			'Trusted?' => {g: 1, h: 1},
			'Praised?' => {g: 2},
			'Liked?' => {h: 2},
			'Feared?' => {s: 2}
		},
		:power => {
			'The power to read minds' => {r: 1, s: 1},
			'The power of invisibility' => {g: 2},
			'The power of superhuman strength' => {h: 2, s: 1},
			'The power to speak to animals' => {h: 2},
			'The power to change the past' => {s: 2, g: 1},
			'The power to change your appearance at will' => {r: 2}
		},
		:look_forward_learn => {
			'Apparition and Disapparition (being able to materialize and dematerialize at will)' => {s: 2, g: 1},
			'Transfiguration (turning one object into another object)' => {r: 2},
			'Flying on a broomstick' => {g: 1, h: 1},
			'Hexes and jinxes' => {s: 2},
			'All about magical creatures, and how to befriend/care for them' => {h: 2},
			'Secrets about the castle' => {g: 2},
			'Every area of magic I can' => {r: 2}
		},
		:most_like_study => {
			'Centaurs' => {g: 2, r: 1},
			'Goblins' => {r: 2},
			'Merpeople' => {h: 1, s: 1},
			'Ghosts' => {g: 2, r: 1},
			'Vampires' => {s: 2},
			'Werewolves' => {g: 2, s: 1},
			'Trolls' => {h: 2, s: 1}
		},
		:bridge => {
			'Attempt to confuse the troll into letting all three of you pass without fighting?' => {r: 1},
			'Suggest drawing lots to decide which of you will fight?' => {h: 1},
			'Suggest that all three of you should fight (without telling the troll)?' => {s: 1},
			'Volunteer to fight?' => {g: 1}
		},
		:cheating => {
			'Lie and say you don’t know (but hope that somebody else tells Professor Flitwick the truth).' => {h: 1},
			'Tell Professor Flitwick that he ought to ask your classmate (and resolve to tell your classmate that if he doesn’t tell the truth, you will).' => {g: 1},
			'Tell Professor Flitwick the truth. If your classmate is prepared to win by cheating, he deserves to be found out. Also, as you are both in the same house, any points he loses will be regained by you, for coming first in his place.' => {r: 1},
			'You would not wait to be asked to tell Professor Flitwick the truth. If you knew that somebody was using a forbidden quill, you would tell the teacher before the exam started.' => {s: 1}
		},
		:muggle => {
			'Ask what makes them think so?' => {r: 1},
			'Agree, and ask whether they’d like a free sample of a jinx?' => {s: 1},
			'Agree, and walk away, leaving them to wonder whether you are bluffing?' => {g: 1},
			'Tell them that you are worried about their mental health, and offer to call a doctor.' => {h: 1}
		},
		:nightmare => {
			'Standing on top of something very high and realizing suddenly that there are no hand- or footholds, nor any barrier to stop you falling.' => {r: 1},
			'An eye at the keyhole of the dark, windowless room in which you are locked.' => {g: 1},
			'Waking up to find that neither your friends nor your family have any idea who you are.' => {h: 1},
			'Being forced to speak in such a silly voice that hardly anyone can understand you, and everyone laughs at you.' => {s: 1}
		},
		:road => {
			'The wide, sunny, grassy lane' => {h: 1},
			'The narrow, dark, lantern-lit alley' => {s: 1},
			'The twisting, leaf-strewn path through woods' => {g: 1},
			'The cobbled street lined with ancient buildings' => {r: 1}
		},
		:street => {
			'Proceed with caution, keeping one hand on your concealed wand and an eye out for any disturbance?' => {h: 1},
			'Draw your wand and try to discover the source of the noise?' => {g: 1},
			'Draw your wand and stand your ground?' => {s: 1},
			'Withdraw into the shadows to await developments, while mentally reviewing the most appropriate defensive and offensive spells, should trouble occur?' => {r: 1}
		},
		:pet => {
			'Tabby cat' => {g: 1},
			'Siamese cat' => {s: 1},
			'Ginger cat' => {s: 1},
			'Black cat' => {s: 1},
			'White cat' => {s: 1},
			'Tawny owl' => {r: 1},
			'Screech owl' => {r: 1},
			'Brown owl' => {r: 1},
			'Snowy owl' => {r: 1},
			'Barn owl' => {r: 1},
			'Common toad' => {h: 1},
			'Natterjack toad' => {h: 1},
			'Dragon toad' => {g: 1},
			'Harlequin toad' => {h: 1},
			'Three toed tree toad' => {r: 1}
		},
		:black_white => {
			'Black' => {g: 1, s: 1},
			'White' => {r: 1, h: 1},
		},
		:heads_tails => {
			'Heads' => {r: 1, h: 1},
			'Tails' => {g: 1, s: 1},
		},
		:left_right => {
			'Left' => {r: 1, s: 1},
			'Right' => {g: 1, h: 1},
		}
	}

	LONG_LENGTH = 80

	def self.num_questions
		QUESTIONS_SELECTIONS.count
	end

	def self.sum_chances(chances1, chances2)
		ret_chances = {}
		ret_chances[:g] = (chances1[:g]||0) + (chances2[:g]||0)
		ret_chances[:r] = (chances1[:r]||0) + (chances2[:r]||0)
		ret_chances[:h] = (chances1[:h]||0) + (chances2[:h]||0)
		ret_chances[:s] = (chances1[:s]||0) + (chances2[:s]||0)
		ret_chances
	end

	def self.question(question_number, bot, message, parameters)
		count = QUESTIONS_SELECTIONS[question_number].count
		question = QUESTIONS_SELECTIONS[question_number][rand(count)]

		self.question_ask(question_number, bot, message, question)
		return question
	end

	def self.answer(question_number, question, answer, chances)
		long_answer = QUESTIONS_DETAILED[question][1].map { |el| el.size > LONG_LENGTH }.any?

		if(long_answer)
			unless (answer >= 'A' && answer <= ('A'.ord + QUESTIONS_DETAILED[question][1].count).chr)
				return nil
			end

			answer = QUESTIONS_DETAILED[question][1][(answer.ord-'A'.ord)]
		else
			possible_answers = QUESTIONS_DETAILED[question][1]
			unless possible_answers.include?(answer)
				return nil
			end
		end

		chances = self.sum_chances(chances, QUESTION_CHANCES[question][answer])

		return chances
	end

	def self.split_into_chunks(array)
		if(array.count > 4)
			chunk_size = 4
			if(array.count % 4 != 0 && array.count % 3 == 0)
				chunk_size = 3
			end
			chunks = (array.count / chunk_size) + 1
			old_array = array
			array = []
			chunks.times do |i|
				array << old_array[i*chunk_size..i*chunk_size + chunk_size-1]
			end
		end
		array
	end

	def self.question_ask(question_number, bot, message, question)
		long_answer = QUESTIONS_DETAILED[question][1].map { |el| el.size > LONG_LENGTH }.any?

		adjusted_question = QUESTIONS_DETAILED[question][0]

		kb = QUESTIONS_DETAILED[question][1]
		if(long_answer)
			kb = []
			adjusted_question = adjusted_question + "\n\n"
			QUESTIONS_DETAILED[question][1].count.times do |i|
				kb << ('A'.ord + i).chr
				adjusted_question << "#{('a'.ord + i).chr}. #{QUESTIONS_DETAILED[question][1][i]}\n"
			end
		end

		kb = split_into_chunks(kb)

		answers = Telegram::Bot::Types::ReplyKeyboardMarkup.new(keyboard: kb, one_time_keyboard: true)

		bot.api.send_message(chat_id: message.chat.id, text: adjusted_question, reply_markup: answers)
	end

	def self.result(chances)
		houses = [:g, :r, :h, :s].reverse
		sorted = chances.sort_by {|house, chance| [chance, houses.index(house)]}.reverse
		return self.house(sorted[0][0])
	end

	def self.house(symb)
		case symb
		when :g
			{id: 2, name: 'Grifinória'}
		when :r
			{id: 1, name: 'Corvinal'}
		when :h
			{id: 3, name: 'Lufa-lufa'}
		when :s
			{id: 4, name: 'Sonserina'}
		end
	end
end
