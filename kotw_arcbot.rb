require 'irc'

match /^(?!!kotw)(?<everything>.+)/ do
  words = everything.split(/ +/)
  words.each do |word|
    store('kotw:word').zincrby word, 1, nick
  end
end

match /^!kotw +(?<word>.+)$/ do
  scores = store('kotw:word').zrevrange(word, 0, 2, with_scores: true)

  if !scores
    reply "I haven't seen anybody say '#{word}'."
    scores = []
  end

  scores.each do |tuple|
    who, score = tuple
    reply "#{who} has said '#{word}' #{'time'.pluralize(score.to_i)}.", false
  end
end
