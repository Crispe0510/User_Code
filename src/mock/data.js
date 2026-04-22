/** ────────────────────────────────────────────────────────
 *  Scenarios
 *  Original 6 (scene-based) + 4 new category-based
 * ──────────────────────────────────────────────────────── */
export const scenarios = [
  {
    id: 's1', title: 'Mealtime Together', subtitle: 'Stories over shared food',
    topicCount: 3, icon: '🍽',
    cover: 'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=800&q=80',
  },
  {
    id: 's2', title: 'Watching TV / Videos', subtitle: 'Connecting through shows',
    topicCount: 3, icon: '📺',
    cover: 'https://images.unsplash.com/photo-1574375927938-d5a98e8ffe85?w=800&q=80',
  },
  {
    id: 's3', title: 'Walking Outdoors', subtitle: 'Conversations on the move',
    topicCount: 3, icon: '🌿',
    cover: 'https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=800&q=80',
  },
  {
    id: 's4', title: 'Car Rides & Travel', subtitle: 'Stories from the journey',
    topicCount: 3, icon: '🚗',
    cover: 'https://images.unsplash.com/photo-1469854523086-cc02fe5d8800?w=800&q=80',
  },
  {
    id: 's5', title: 'Cooking & Chores', subtitle: 'Bonding through daily tasks',
    topicCount: 3, icon: '🍳',
    cover: 'https://images.unsplash.com/photo-1556910103-1c02745aae4d?w=800&q=80',
  },
  {
    id: 's6', title: 'Resting at Home', subtitle: 'Quiet moments together',
    topicCount: 3, icon: '🏠',
    cover: 'https://images.unsplash.com/photo-1586023492125-27b2c045efd7?w=800&q=80',
  },
  // ── 4 Category-based scenarios from topic bank ──
  {
    id: 'cat-people', title: 'People & Relationships', subtitle: 'Discuss inspiring people in your lives',
    topicCount: 10, icon: '👥',
    cover: 'https://images.unsplash.com/photo-1529156069898-49953e39b3ac?w=800&q=80',
  },
  {
    id: 'cat-place', title: 'Places & Occasions', subtitle: 'Explore memorable places and moments',
    topicCount: 4, icon: '🗺',
    cover: 'https://images.unsplash.com/photo-1501854140801-50d01698950b?w=800&q=80',
  },
  {
    id: 'cat-object', title: 'Objects & Interests', subtitle: 'Share stories behind things that matter',
    topicCount: 16, icon: '📦',
    cover: 'https://images.unsplash.com/photo-1516483638261-f4dbaf036963?w=800&q=80',
  },
  {
    id: 'cat-events', title: 'Events & Experiences', subtitle: 'Relive and share life experiences together',
    topicCount: 23, icon: '🎯',
    cover: 'https://images.unsplash.com/photo-1540575467063-178a50c2df87?w=800&q=80',
  },
]

/** ────────────────────────────────────────────────────────
 *  Topics  (original scene-based + all neirong.txt content)
 * ──────────────────────────────────────────────────────── */
export const topics = [
  // ── Scene-based (original 6 scenarios) ──────────────────
  {
    id: 't-childhood-food', scenarioId: 's1',
    title: 'Taste of Childhood', titleSub: 'Food memories across generations',
    recommend: 'Food is the most natural conversation starter at the table. Childhood flavours trigger powerful emotions and memories — and comparing eating habits across generations reveals fascinating differences.',
    opening: [
      'What was your all-time favourite dish as a child?',
      'Is there one food that instantly takes you back to your childhood?',
      'What was the first dish you ever tried to cook yourself?',
      'What special dishes did the family always make for the New Year?',
    ],
    deep: [
      'How did the quality of food and daily life compare to today?',
      'Is there a special story behind one of those recipes?',
      'Which family recipes do you hope will be passed down forever?',
    ],
  },
  {
    id: 't-table-news', scenarioId: 's1',
    title: 'News at the Table', titleSub: 'Lighthearted updates from the week',
    recommend: 'Sharing small recent moments is more inviting than formal questions, and makes for easy, warm conversation.',
    opening: [
      'What was a small thing that made you smile this week?',
      'Have you seen anything interesting on the news or online lately?',
      'If you could share just one thing with the family right now, what would it be?',
    ],
    deep: [
      'How has the feeling around family mealtimes changed over the years?',
      'Is there something you have been meaning to tell the family but never found the right moment?',
    ],
  },
  {
    id: 't-food-habit', scenarioId: 's1',
    title: 'Tastes & Habits', titleSub: 'Salt, spice, and the things we love',
    recommend: 'From sweet versus savoury to picky eating and wellness routines, generational differences often hold a few surprises.',
    opening: [
      'Do you prefer rice or noodles?',
      'Is there a food you hated as a child but love now?',
      'Who in the family has the best instinct for seasoning?',
    ],
    deep: [
      'How do you balance "healthy" with "delicious"?',
      'Is there one dish that truly tastes like home to you?',
    ],
  },
  {
    id: 't-show-share', scenarioId: 's2',
    title: 'What We Watch', titleSub: 'Talking about shows and stories',
    recommend: 'Building on what is already on screen makes the conversation feel effortless rather than forced.',
    opening: [
      'Which moment in this show surprised you the most?',
      'If you were in that situation, what would you have done?',
      'Has anything like that ever happened in our own family?',
    ],
    deep: [
      'What is the biggest difference between watching TV as a child and watching it today?',
      'What does watching TV together as a family mean to you?',
    ],
  },
  {
    id: 't-walk-memory', scenarioId: 's3',
    title: 'Memories on the Road', titleSub: 'Places that hold a piece of your heart',
    recommend: 'Walking loosens the body and the mind. Talking about the scenery and old places comes naturally when you are already moving.',
    opening: [
      'Does this street or path remind you of anything?',
      'Where did you like to play or hang out as a child?',
      'Which season do you enjoy walking in the most?',
    ],
    deep: [
      'Is there a particular route that holds a special meaning for you?',
      'If you could walk one road from your past again, who would you bring?',
    ],
  },
  {
    id: 't-travel-snack', scenarioId: 's4',
    title: 'Snacks on the Road', titleSub: 'Little bites and big journeys',
    recommend: 'Food and travel memories are a light, cheerful gateway into intergenerational conversation.',
    opening: [
      'What snack do you always bring on a trip?',
      'What is the most memorable journey you have ever taken?',
      'Is the food at a service station better, or food packed from home?',
    ],
    deep: [
      'On a trip, do you care more about the scenery or the people you are with?',
      'Has a journey ever changed the way you see something?',
    ],
  },

  // ── People & Relationships (cat-people) ─────────────────
  {
    id: 'p-popular-person', scenarioId: 'cat-people',
    title: 'A Popular Person', titleSub: 'Describe a popular person you know',
    recommend: 'Talking about popular people opens discussions on values and social dynamics that span generations.',
    opening: [
      'Why are some students popular in school?',
      'Is it important for a teacher to be popular?',
      'Do you think good teachers are always popular among students?',
    ],
    deep: [
      'What are the qualities of being a good teacher?',
      'Is it easier to become popular nowadays?',
      'Why do people want to be popular?',
    ],
  },
  {
    id: 'p-sportsperson', scenarioId: 'cat-people',
    title: 'An Inspiring Athlete', titleSub: 'Describe a successful sportsperson you admire',
    recommend: 'Sports figures often inspire cross-generational admiration and spark lively debates about talent vs effort.',
    opening: [
      'Should students have physical education and do sports at school?',
      'What qualities should an athlete have?',
      'Is talent important in sports?',
    ],
    deep: [
      'Is it easy to identify children\'s talents?',
      'What is the most popular sport in your country?',
      'Why are there so few top athletes?',
    ],
  },
  {
    id: 'p-creative-person', scenarioId: 'cat-people',
    title: 'A Creative Person', titleSub: 'Describe a creative person (artist, musician, architect…) you admire',
    recommend: 'Creativity means different things to different generations — this topic sparks rich discussion on art, inspiration and expression.',
    opening: [
      'Do you think children should learn to play musical instruments?',
      'How do artists acquire inspiration?',
      'Do you think pictures and videos in news reports are important?',
    ],
    deep: [
      'What can we do to help children stay creative?',
      'How does drawing help to enhance children\'s creativity?',
      'What kind of jobs require creativity?',
    ],
  },
  {
    id: 'p-good-friend', scenarioId: 'cat-people',
    title: 'An Important Friend', titleSub: 'Describe a good friend who is important to you',
    recommend: 'Friendship looks very different across generations — this topic bridges the gap between childhood bonds and adult relationships.',
    opening: [
      'How do children make friends at school?',
      'How do children make friends when they are not at school?',
      'Do you think it is better for children to have a few close friends or many casual friends?',
    ],
    deep: [
      'Can a child\'s relationship with friends be replaced by that with parents or family?',
      'What are the differences between friends made inside and outside the workplace?',
      'Do you think it\'s possible for bosses and their employees to become friends?',
    ],
  },
  {
    id: 'p-music-friend', scenarioId: 'cat-people',
    title: 'A Friend Who Loves Music', titleSub: 'Describe a friend who is good at singing or music',
    recommend: 'Music preferences reveal generational gaps beautifully — this topic often leads to fun comparisons and shared memories.',
    opening: [
      'What kind of music is popular in your country?',
      'What kind of music do young people like?',
      'What are the differences between young and older people\'s music preferences?',
    ],
    deep: [
      'What are the benefits of children learning a musical instrument?',
      'Do you know what kind of music children like today?',
      'Do you think the government should invest more money in concerts?',
    ],
  },
  {
    id: 'p-famous-person', scenarioId: 'cat-people',
    title: 'A Famous Person to Meet', titleSub: 'Describe a famous person you would like to meet',
    recommend: 'Imagining meeting a hero sparks wonderful storytelling and reveals what each generation truly values.',
    opening: [
      'What are the advantages and disadvantages of being a famous child?',
      'What can today\'s children do to become famous?',
      'What can children do with their fame?',
    ],
    deep: [
      'Do people become famous because of their talent?',
    ],
  },
  {
    id: 'p-planner', scenarioId: 'cat-people',
    title: 'A Great Planner', titleSub: 'Describe a person who is good at planning',
    recommend: 'Planning habits differ greatly between generations — this topic opens up honest conversations about life decisions and the future.',
    opening: [
      'Do you think it\'s important to plan ahead?',
      'What activities do we need to plan ahead?',
      'Do you think children should plan their future careers?',
    ],
    deep: [
      'Should children ask their teachers or parents for advice when making plans?',
      'Is making study plans popular among young people?',
      'Do you think choosing a college major is closely related to a person\'s future career?',
    ],
  },
  {
    id: 'p-drawing-friend', scenarioId: 'cat-people',
    title: 'A Friend Who Loves Drawing', titleSub: 'Describe a friend who loves drawing or painting',
    recommend: 'Art and drawing connect generations — sharing memories of drawing as a child often brings out touching stories.',
    opening: [
      'What is the right age for a child to learn drawing?',
      'Why do most children draw more often than adults do?',
      'Why do some people visit galleries instead of viewing artworks online?',
    ],
    deep: [
      'Do you think galleries and museums should be free of charge?',
      'How do artworks inspire people?',
    ],
  },
  {
    id: 'p-nature-person', scenarioId: 'cat-people',
    title: 'Someone Who Loves Nature', titleSub: 'Describe a person who encouraged you to protect nature',
    recommend: 'Environmental values are often passed between generations — this topic encourages reflection on our shared responsibilities.',
    opening: [
      'How can parents teach their children to protect nature?',
      'Should schools teach children to get close to nature?',
      'Do you think there should be laws to protect nature?',
    ],
    deep: [],
  },
  {
    id: 'p-helpful-person', scenarioId: 'cat-people',
    title: 'A Helpful Person', titleSub: 'Describe a person who often helps others',
    recommend: 'Stories about helping others are universal and cross all generations — this topic builds warmth and appreciation.',
    opening: [
      'Should children help their parents with household chores?',
      'What kind of help do people need when looking for a new job?',
      'Who should people ask for help — colleagues or family members?',
    ],
    deep: [],
  },

  // ── Places & Occasions (cat-place) ──────────────────────
  {
    id: 'pl-trees', scenarioId: 'cat-place',
    title: 'A Place Full of Trees', titleSub: 'Describe a place with many trees you\'d like to visit',
    recommend: 'Nature and green spaces evoke nostalgia and wonder across ages — a great way to share childhood memories of the outdoors.',
    opening: [
      'Why do people like visiting places with trees or forests?',
      'Are natural views better than city views?',
      'Do all people need some connection with nature?',
    ],
    deep: [
      'Are people instinctively inclined to protect the environment?',
    ],
  },
  {
    id: 'pl-natural', scenarioId: 'cat-place',
    title: 'A Natural Place', titleSub: 'Describe a natural place (park, mountain…) you enjoy',
    recommend: 'Natural places mean different things to different generations — sharing these memories builds mutual understanding.',
    opening: [
      'What kind of people like to visit natural places?',
      'What are the differences between a natural place and a city?',
      'Do you think going to the park is the only way to get close to nature?',
    ],
    deep: [
      'What can people gain from going to natural places?',
      'Are there any wild animals in the city?',
      'Do you think it is a good idea to let animals stay in local parks for people to see?',
    ],
  },
  {
    id: 'pl-no-phone', scenarioId: 'cat-place',
    title: 'No-Phone Moments', titleSub: 'Describe an occasion when you were not allowed to use your phone',
    recommend: 'Mobile phone usage is a hot topic between generations — this leads to fascinating and sometimes funny debates.',
    opening: [
      'How do young and old people use mobile phones differently?',
      'What positive and negative impact do mobile phones have on friendship?',
      'Is it a waste of time to take pictures with mobile phones?',
    ],
    deep: [
      'Do you think it is necessary to have laws on the use of mobile phones?',
    ],
  },
  {
    id: 'pl-smiling', scenarioId: 'cat-place',
    title: 'When Everyone Was Smiling', titleSub: 'Describe an occasion when many people were smiling',
    recommend: 'Revisiting joyful moments together is a simple but powerful way to strengthen family bonds.',
    opening: [
      'Do you think people who like to smile are more friendly?',
      'Why do most people smile in photographs?',
      'Do women smile more than men? Why?',
    ],
    deep: [
      'Do people smile more when they are younger or older?',
    ],
  },

  // ── Objects & Interests (cat-object) ────────────────────
  {
    id: 'ob-invention', scenarioId: 'cat-object',
    title: 'A Useful Invention', titleSub: 'Describe an invention that is useful in your daily life',
    recommend: 'Comparing the inventions that shaped different eras is a fascinating way to appreciate change across generations.',
    opening: [
      'What qualities do inventors have?',
      'Do you think only scientists can invent new things?',
      'What inventions do you think should be improved?',
    ],
    deep: [
      'Are there any other inventions that make the world better?',
      'Do all inventions bring benefits to our world?',
      'Who should support inventors — governments or private companies?',
    ],
  },
  {
    id: 'ob-toy', scenarioId: 'cat-object',
    title: 'A Childhood Toy', titleSub: 'Describe a toy you liked in your childhood',
    recommend: 'Toys are portals to childhood — sharing toy memories often brings laughter and reveals the values of each era.',
    opening: [
      'How do advertisements influence children?',
      'Should advertising aimed at kids be prohibited?',
      'What\'s the difference between toys kids play with now and those in the past?',
    ],
    deep: [
      'Do you think parents should buy more toys or spend more time with their kids?',
      'What\'s the difference between toys boys and girls play with?',
      'What are the advantages and disadvantages of modern toys?',
    ],
  },
  {
    id: 'ob-book', scenarioId: 'cat-object',
    title: 'A Useful Book', titleSub: 'Describe a book you read that you found useful',
    recommend: 'Books have shaped every generation differently — sharing favourite reads opens wonderful conversations about knowledge and wisdom.',
    opening: [
      'What are the types of books that young people like to read?',
      'What should the government do to make libraries better?',
      'Do you think old people spend more time reading than young people?',
    ],
    deep: [
      'Which one is better, paper books or e-books?',
      'Have libraries changed a lot with the development of the internet?',
      'What should we do to prevent modern libraries from closing down?',
    ],
  },
  {
    id: 'ob-science', scenarioId: 'cat-object',
    title: 'A Science Subject', titleSub: 'Describe an area of science you are interested in',
    recommend: 'Science curiosity is ageless — exploring what each generation found fascinating reveals how knowledge and wonder evolve.',
    opening: [
      'Why do some children not like learning science at school?',
      'Is it important to study science at school?',
      'Which science subject is the most important for children to learn?',
    ],
    deep: [
      'Should people continue to study science after graduating from school?',
      'How do you get to know about scientific news?',
      'Should scientists explain the research process to the public?',
    ],
  },
  {
    id: 'ob-old-thing', scenarioId: 'cat-object',
    title: 'A Family Heirloom', titleSub: 'Describe an important old thing your family has kept',
    recommend: 'Family heirlooms are living stories — every item holds history that bridges the gap between generations.',
    opening: [
      'What kind of old things do people in your country like to keep?',
      'Why do people keep old things?',
      'What are the differences between the things old and young people keep?',
    ],
    deep: [
      'What are the differences between the things people keep today versus in the past?',
      'What can we see in a museum?',
      'What can we learn from a museum?',
    ],
  },
  {
    id: 'ob-story', scenarioId: 'cat-object',
    title: 'A Traditional Story', titleSub: 'Describe an interesting traditional story',
    recommend: 'Traditional stories carry cultural values — comparing stories across generations reveals how values are passed down.',
    opening: [
      'What kind of stories do children like?',
      'What are the benefits of bedtime stories for children?',
      'Why do most children like listening to stories before bedtime?',
    ],
    deep: [
      'What can children learn from stories?',
      'Do all stories for children have happy endings?',
      'Is a good storyline important for a movie?',
    ],
  },
  {
    id: 'ob-talent', scenarioId: 'cat-object',
    title: 'A Talent to Improve', titleSub: 'Describe a natural talent (sports, music…) you want to develop',
    recommend: 'Talking about talent and potential connects generations through shared dreams and experiences of growth.',
    opening: [
      'Do you think artists with talents should focus on their talents?',
      'Is it possible to know whether young children will become musicians or painters when they grow up?',
      'Why do people like to watch talent shows?',
    ],
    deep: [
      'Do you think it is more interesting to watch famous or ordinary people\'s shows?',
      'Do you think it\'s important to develop children\'s talents?',
      'Why do some people like to show their talents online?',
    ],
  },
  {
    id: 'ob-wild-animal', scenarioId: 'cat-object',
    title: 'A Wild Animal', titleSub: 'Describe a wild animal you want to learn more about',
    recommend: 'Wildlife and nature connect us to the bigger world — this topic sparks conversations about values, environment and childhood wonder.',
    opening: [
      'Why should we protect wild animals?',
      'Why are some people more willing to protect wild animals than others?',
      'Do you think it\'s important to take children to the zoo to see animals?',
    ],
    deep: [
      'Why do some people attach more importance to protecting rare animals?',
      'Should people educate children to protect wild animals?',
      'Is it more important to protect wild animals or the environment?',
    ],
  },
  {
    id: 'ob-building', scenarioId: 'cat-object',
    title: 'An Interesting Building', titleSub: 'Describe an interesting building you saw during a trip',
    recommend: 'Architecture and travel connect personal history to culture — sharing discoveries from travels is naturally engaging across ages.',
    opening: [
      'Should all scenic spots charge an entry fee?',
      'Is visiting scenic spots the best choice while travelling?',
      'Why do some people like to live in big cities?',
    ],
    deep: [
      'Is it necessary for tourists to visit landmarks when travelling?',
      'Which do most people prefer, living in a bungalow or in a tall building?',
    ],
  },
  {
    id: 'ob-habit', scenarioId: 'cat-object',
    title: 'A Good Habit from a Friend', titleSub: 'Describe a good habit your friend has that you want to develop',
    recommend: 'Habits shape character — discussing good habits is a gentle, positive way to share life lessons between generations.',
    opening: [
      'What habits should children have?',
      'What should parents do to teach their children good habits?',
      'What influences do children with bad habits have on other children?',
    ],
    deep: [
      'Why do some habits change when people get older?',
      'How do we develop bad habits?',
      'What can we do to get rid of bad habits?',
    ],
  },
  {
    id: 'ob-water-sport', scenarioId: 'cat-object',
    title: 'A Water Sport', titleSub: 'Describe a water sport you would like to try',
    recommend: 'Sports and water evoke summer memories and physical adventures — great for sharing playful childhood experiences.',
    opening: [
      'Do you think it is good to teach swimming in school?',
      'What kinds of water sports are popular nowadays?',
      'Why do people like to live near water?',
    ],
    deep: [
      'What are the advantages of water transportation?',
      'What do you think of people who waste water?',
      'What are the characteristics of goods transported by water?',
    ],
  },
  {
    id: 'ob-dream-job', scenarioId: 'cat-object',
    title: 'Your Dream Job', titleSub: 'Describe your perfect job',
    recommend: 'Career aspirations reveal generational shifts in values — comparing dreams across ages opens honest and meaningful conversations.',
    opening: [
      'What kind of job can be called a "dream job"?',
      'What jobs do children want to do when they grow up?',
      'Do people\'s ideal jobs change as they grow up?',
    ],
    deep: [
      'What should people consider when choosing jobs?',
      'Is salary the main reason why people choose a certain job?',
    ],
  },
  {
    id: 'ob-technology', scenarioId: 'cat-object',
    title: 'A Cool Technology', titleSub: 'Describe a piece of technology (not a phone) you would like to own',
    recommend: 'Technology has transformed daily life across generations — comparing past and present tech is always eye-opening.',
    opening: [
      'What are the differences between the technology of the past and that of today?',
      'What technology do young people like to use?',
      'What are the differences between online and face-to-face communication?',
    ],
    deep: [],
  },
  {
    id: 'ob-app', scenarioId: 'cat-object',
    title: 'A Favourite App', titleSub: 'Describe an app or program you use on your phone or computer',
    recommend: 'Apps are a generational dividing line — comparing how different family members use technology sparks lively and fun discussion.',
    opening: [
      'What are the differences between old and young people when using apps?',
      'Why do some people not like using apps?',
      'What apps are popular in your country? Why?',
    ],
    deep: [
      'Should parents limit their children\'s use of computer games? Why and how?',
      'Do you think young people are becoming more and more reliant on these programs?',
    ],
  },
  {
    id: 'ob-family-thing', scenarioId: 'cat-object',
    title: 'Something Important to the Family', titleSub: 'Describe something important your family has kept for a long time',
    recommend: 'Family treasures carry emotional weight — sharing their stories is a beautiful way to pass down family history.',
    opening: [
      'What things do families keep for a long time?',
      'What\'s the difference between things valued by people in the past and today?',
      'What kinds of things are kept in museums?',
    ],
    deep: [
      'What\'s the influence of technology on museums?',
    ],
  },
  {
    id: 'ob-overspend', scenarioId: 'cat-object',
    title: 'An Unexpected Expense', titleSub: 'Describe an item on which you spent more than expected',
    recommend: 'Money habits differ greatly across generations — this topic opens honest conversations about spending, saving and values.',
    opening: [
      'Do you often buy more than you expected?',
      'What do you think young people spend most of their money on?',
      'Do you think it is important to save money? Why?',
    ],
    deep: [
      'Do people buy things they don\'t need?',
    ],
  },

  // ── Events & Experiences (cat-events) ───────────────────
  {
    id: 'ev-long-journey', scenarioId: 'cat-events',
    title: 'A Long Journey', titleSub: 'Describe a long journey you had and would like to take again',
    recommend: 'Travel stories are among the richest shared experiences — revisiting journeys reveals how they shaped us.',
    opening: [
      'Do you think it is a good choice to travel by plane?',
      'What are the differences between group travelling and travelling alone?',
      'What do we need to prepare for a long journey?',
    ],
    deep: [
      'Why do some people like making long journeys?',
      'Why do some people prefer to travel in their own country?',
      'Why do some people prefer to travel abroad?',
    ],
  },
  {
    id: 'ev-broke-something', scenarioId: 'cat-events',
    title: 'When You Broke Something', titleSub: 'Describe a time when you broke something',
    recommend: 'Oops moments are universally relatable — comparing how generations handle breakage and repairs sparks laughter and wisdom.',
    opening: [
      'What kind of things are most likely to be broken at home?',
      'What kind of people like to fix things by themselves?',
      'Do you think clothes produced in factories are better quality than handmade ones?',
    ],
    deep: [
      'Do you think handmade clothes are more valuable?',
      'Is the older generation better at fixing things?',
      'Do you think elderly people should teach young people how to fix things?',
    ],
  },
  {
    id: 'ev-decision', scenarioId: 'cat-events',
    title: 'A Decision Made Together', titleSub: 'Describe an important decision made with help from others',
    recommend: 'Decision-making is deeply personal yet shaped by community — sharing experiences reveals how generations approach life choices differently.',
    opening: [
      'What kind of decisions do you think are meaningful?',
      'What important decisions should be made by teenagers themselves?',
      'Why are some people unwilling to make quick decisions?',
    ],
    deep: [
      'Do people like to ask for advice more for their personal life or their work?',
      'Why do some people like to ask others for advice?',
    ],
  },
  {
    id: 'ev-gave-advice', scenarioId: 'cat-events',
    title: 'When You Gave Advice', titleSub: 'Describe a time when you gave advice to others',
    recommend: 'Advice-giving is a powerful act of trust — discussing when and how to give advice bridges generational wisdom beautifully.',
    opening: [
      'Should people prepare before giving advice?',
      'Is it good to ask advice from strangers online?',
      'What are the personalities of people whose job is to give advice?',
    ],
    deep: [
      'What are the problems if you ask too many people for advice?',
    ],
  },
  {
    id: 'ev-power-cut', scenarioId: 'cat-events',
    title: 'When the Lights Went Out', titleSub: 'Describe a time when the electricity suddenly went off',
    recommend: 'Power cuts are memorable events — comparing reactions across generations reveals how much (or little) we rely on electricity.',
    opening: [
      'Which is better, electric bicycles or ordinary bicycles?',
      'Which is better, electric cars or petrol cars?',
      'How did people manage to live without electricity in the ancient world?',
    ],
    deep: [
      'Do electric bicycles replace ordinary bicycles in the future?',
      'Is it difficult for the government to replace all petrol cars with electric ones?',
      'Do people use more electricity now than before?',
    ],
  },
  {
    id: 'ev-exciting-first', scenarioId: 'cat-events',
    title: 'An Exciting First', titleSub: 'Describe an exciting activity you tried for the first time',
    recommend: 'First-time experiences are unforgettable — sharing them sparks enthusiasm and builds connections across generations.',
    opening: [
      'Why are some people unwilling to try new things?',
      'Do you think fear stops people from trying new things?',
      'Why are some people keen on doing dangerous activities?',
    ],
    deep: [
      'Do you think that children adapt to new things more easily than adults?',
      'What can people learn from doing challenging activities?',
      'What are the benefits of trying new things?',
    ],
  },
  {
    id: 'ev-positive-change', scenarioId: 'cat-events',
    title: 'A Positive Change', titleSub: 'Describe a positive change you made recently in your daily routine',
    recommend: 'Change and growth are lifelong processes — comparing how we evolve resonates deeply across all ages.',
    opening: [
      'What do people normally plan in their daily lives?',
      'Is time management very important in our daily lives?',
      'What changes would people often make?',
    ],
    deep: [
      'Do you think it is good to change jobs frequently?',
      'Who makes changes more often — young people or older people?',
      'Who should get more promotion opportunities, young or older people?',
    ],
  },
  {
    id: 'ev-good-service', scenarioId: 'cat-events',
    title: 'Great Service', titleSub: 'Describe a time when you received good service in a shop',
    recommend: 'Service experiences reflect social norms that have shifted dramatically across generations — a rich topic for storytelling.',
    opening: [
      'Why are shopping malls so popular in China?',
      'What are the advantages and disadvantages of shopping in small shops?',
      'Why do some people not like shopping in small shops?',
    ],
    deep: [
      'What are the differences between online shopping and in-store shopping?',
      'What are the advantages and disadvantages of shopping online?',
      'Can consumption drive economic growth?',
    ],
  },
  {
    id: 'ev-speech', scenarioId: 'cat-events',
    title: 'A Speech You Gave', titleSub: 'Describe a talk you gave to a group of people',
    recommend: 'Public speaking is a universal challenge — comparing how we communicate across generations uncovers shared vulnerabilities and growth.',
    opening: [
      'What benefits does the internet bring to communication?',
      'Which one is better — being a communicator or a listener?',
      'What qualities does a person need to be a good communicator?',
    ],
    deep: [
      'What qualities do people need to speak in public?',
      'How important is it to be a good listener when communicating?',
      'What kinds of people often give speeches?',
    ],
  },
  {
    id: 'ev-unusual-meal', scenarioId: 'cat-events',
    title: 'An Unusual Meal', titleSub: 'Describe an unusual meal you had',
    recommend: 'Food adventures connect us to culture and memory — sharing unusual meals often leads to funny and vivid stories.',
    opening: [
      'What are the advantages and disadvantages of eating in restaurants?',
      'What fast food restaurants are there in your country?',
      'Do people eat fast food at home?',
    ],
    deep: [
      'Why do some people choose to eat out instead of ordering takeout?',
      'Do people in your country socialise in restaurants?',
      'Do people in your country value food culture?',
    ],
  },
  {
    id: 'ev-waiting', scenarioId: 'cat-events',
    title: 'Waiting for Something Special', titleSub: 'Describe a time when you waited for something important',
    recommend: 'Patience and anticipation mean different things to different generations — this topic opens up conversations about values and expectations.',
    opening: [
      'On what occasions do people usually need to wait?',
      'Who behaves better when waiting — children or adults?',
      'Compared to the past, are people less patient now? Why?',
    ],
    deep: [
      'What are the positive and negative effects of waiting on society?',
      'Why are some people unwilling to wait?',
      'Where do children learn to be patient — at home or at school?',
    ],
  },
  {
    id: 'ev-social-media', scenarioId: 'cat-events',
    title: 'Something Interesting on Social Media', titleSub: 'Describe a time you saw something interesting on social media',
    recommend: 'Social media is a generational dividing line — comparing experiences of it can be both enlightening and entertaining.',
    opening: [
      'Why do people like to use social media?',
      'What kinds of things are popular on social media?',
      'What are the advantages and disadvantages of using social media?',
    ],
    deep: [
      'What do you think of making friends on social networks?',
      'Are there any people who shouldn\'t use social media?',
      'Do you think people spend too much time on social media?',
    ],
  },
  {
    id: 'ev-told-truth', scenarioId: 'cat-events',
    title: 'Telling an Important Truth', titleSub: 'Describe a time when you told your friend an important truth',
    recommend: 'Honesty is a core value that generations sometimes define differently — this topic opens meaningful conversations about trust.',
    opening: [
      'Do you think it\'s more important to win or to follow the rules in sports?',
      'Sometimes people should tell lies. Do you agree?',
      'How do you know when others are telling lies?',
    ],
    deep: [
      'Do you think we should tell the truth at all times?',
    ],
  },
  {
    id: 'ev-foreign-language', scenarioId: 'cat-events',
    title: 'Speaking a Foreign Language', titleSub: 'Describe the first time you talked in a foreign language',
    recommend: 'Language learning experiences vary hugely across generations — sharing them reveals both the challenges and joys of communication.',
    opening: [
      'At what age should children start learning a foreign language?',
      'Which skill is more important — speaking or writing?',
      'Does a person still need to learn other languages if they are good at English?',
    ],
    deep: [
      'Do you think minority languages will disappear?',
      'Does learning a foreign language help in finding a job?',
      'Which stage of life is the best for learning a foreign language?',
    ],
  },
  {
    id: 'ev-lost-way', scenarioId: 'cat-events',
    title: 'Getting Lost', titleSub: 'Describe an occasion when you lost your way',
    recommend: 'Getting lost is both stressful and memorable — comparing how different generations navigated (literally and metaphorically) is fascinating.',
    opening: [
      'Why do some people get lost more easily than others?',
      'Do you think it is important to be able to read a map?',
      'Do you think it is important to do some preparation before travelling to new places?',
    ],
    deep: [
      'How can people find their way when they are lost?',
      'Is a paper map still necessary?',
      'How do people react when they get lost?',
    ],
  },
  {
    id: 'ev-apology', scenarioId: 'cat-events',
    title: 'When Someone Apologised', titleSub: 'Describe a time when someone apologised to you',
    recommend: 'Apologies are cultural and deeply personal — exploring how different generations handle "sorry" opens up rich emotional conversation.',
    opening: [
      'Do you think people should apologise for anything wrong they do?',
      'Do people in your country like to say "sorry"?',
      'On what occasions do people usually apologise to others?',
    ],
    deep: [
      'Why do some people refuse to say "sorry" to others?',
      'Do you think every "sorry" is truly from the heart?',
      'Are women better than men at recognising emotions?',
    ],
  },
  {
    id: 'ev-family-dinner', scenarioId: 'cat-events',
    title: 'A Special Family Dinner', titleSub: 'Describe a great dinner you enjoyed with friends or family',
    recommend: 'Family meals are at the heart of Chinese culture — this topic naturally bridges generations through food and togetherness.',
    opening: [
      'Do people prefer to eat out or eat at home during the Spring Festival?',
      'What food do you eat on special occasions like the Spring Festival or Mid-Autumn Festival?',
      'Why do people like to have meals together during important festivals?',
    ],
    deep: [
      'Is it a hassle to prepare a meal at home?',
      'What do people often talk about during meals?',
      'People are spending less time having meals with their families today. Is this good or bad?',
    ],
  },
  {
    id: 'ev-story-read', scenarioId: 'cat-events',
    title: 'A Story You Read Recently', titleSub: 'Describe a story (fairy tale, etc.) you have read recently',
    recommend: 'Stories and storytelling are timeless — comparing the stories that shaped each generation is both revealing and touching.',
    opening: [
      'Why do most children like listening to stories before bedtime?',
      'Is a good storyline important for a movie?',
      'Do you think films with many celebrities are more likely to be popular?',
    ],
    deep: [
      'What films are popular in China right now?',
    ],
  },
  {
    id: 'ev-proud-family', scenarioId: 'cat-events',
    title: 'Proud of a Family Member', titleSub: 'Describe a time when you felt proud of a family member',
    recommend: 'Pride in family is universal and deeply meaningful — sharing these moments builds connection and affirms what we value most.',
    opening: [
      'When would parents feel proud of their children?',
      'Should parents reward children? Why and how?',
      'Is it good to reward children too often? Why?',
    ],
    deep: [
      'On what occasions would adults feel proud of themselves?',
    ],
  },
  {
    id: 'ev-vehicle-trip', scenarioId: 'cat-events',
    title: 'A Vehicle Trip', titleSub: 'Describe a bicycle / motorcycle / car trip you would like to go on',
    recommend: 'Road trips and vehicle journeys hold memories for every generation — this topic sparks stories of freedom, adventure and change.',
    opening: [
      'Which form of vehicle is more popular in your country — bikes, cars or motorcycles?',
      'Do you think air pollution comes mostly from vehicles?',
      'Do you think people need to change their transport habits to protect the environment?',
    ],
    deep: [
      'How are the transportation systems in urban and rural areas different?',
    ],
  },
  {
    id: 'ev-bad-concert', scenarioId: 'cat-events',
    title: 'A Music Event You Didn\'t Enjoy', titleSub: 'Describe a music event that you didn\'t enjoy',
    recommend: 'Disagreements about music are fun and harmless — this topic leads to lively generational debates about taste.',
    opening: [
      'What kind of music events do people like today?',
      'What kind of music did people enjoy in the past?',
      'What makes a music performance enjoyable?',
    ],
    deep: [],
  },
  {
    id: 'ev-movie', scenarioId: 'cat-events',
    title: 'A Film You Enjoyed', titleSub: 'Describe a movie you watched and enjoyed recently',
    recommend: 'Movies are a universal language — comparing films across generations opens up rich conversations about values, heroes and culture.',
    opening: [
      'What kinds of movies are successful in your country?',
      'What are the factors that make a successful movie?',
      'Do people prefer to watch domestic movies or foreign movies?',
    ],
    deep: [
      'Do you think only well-known directors can create the best movies?',
      'Should successful movies have well-known actors in leading roles?',
      'Why do people prefer to watch movies in the cinema?',
    ],
  },
  {
    id: 'ev-imagination', scenarioId: 'cat-events',
    title: 'When You Used Your Imagination', titleSub: 'Describe a time you needed to use your imagination',
    recommend: 'Imagination is the root of creativity — comparing how different generations express and value imagination is always illuminating.',
    opening: [
      'Do you think adults can have lots of imagination?',
      'Do you think imagination is essential for scientists?',
      'What kinds of jobs need imagination?',
    ],
    deep: [
      'What subjects are helpful for children\'s imagination?',
    ],
  },
]

/** Recent topics */
export const recentTopics = [
  { id: 't-childhood-food', title: 'Taste of Childhood', time: 'Today  10:24', scenarioId: 's1' },
  { id: 'p-good-friend', title: 'An Important Friend', time: 'Yesterday  19:02', scenarioId: 'cat-people' },
  { id: 'ev-family-dinner', title: 'A Special Family Dinner', time: 'Mon  20:15', scenarioId: 'cat-events' },
]

/** Mood Board */
export const moodTypes = [
  { id: 'happy',    emoji: '😊', label: 'Happy',          color: '#FFF9C4' },
  { id: 'peaceful', emoji: '😌', label: 'Peaceful',       color: '#B2EBF2' },
  { id: 'grateful', emoji: '🥰', label: 'Grateful',       color: '#FCE4EC' },
  { id: 'anxious',  emoji: '😟', label: 'A Bit Worried',  color: '#CFD8DC' },
  { id: 'tired',    emoji: '😴', label: 'Tired',          color: '#D1C4E9' },
  { id: 'excited',  emoji: '🎉', label: 'Excited',        color: '#FFE0B2' },
]

export const communicationTips = {
  happy:    "Great time to share what made them smile — ask about the highlight of their day!",
  peaceful: "They're in a calm state. Perfect for a gentle, relaxed chat.",
  grateful: "They're feeling appreciative. Share something you're thankful for too.",
  anxious:  "Be gentle. Listen more, speak less. Just knowing you're there helps.",
  tired:    "Give them space. A simple 'I'm here' or a quiet moment together goes a long way.",
  excited:  "Match their energy! Ask what's got them excited and celebrate together.",
}

export const familyMembers = [
  {
    id: 'm1', name: 'Grandpa', role: 'parent', avatar: '👴',
    today: { mood: 'peaceful', note: 'Had a lovely morning walk today.', time: '08:30' },
  },
  {
    id: 'm2', name: 'Mom', role: 'parent', avatar: '👩',
    today: { mood: 'grateful', note: 'Feeling so blessed with everyone around.', time: '12:15' },
  },
  {
    id: 'm3', name: 'Me (You)', role: 'child', avatar: '🧒', today: null,
  },
]

export const weeklyMoods = {
  m1: ['peaceful', 'happy', 'tired', 'peaceful', 'grateful', 'happy', 'peaceful'],
  m2: ['grateful', 'happy', 'anxious', 'peaceful', 'happy', 'excited', 'grateful'],
}

export const weekDayLabels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']

/** Report / Journal */
export const reportTimeline = [
  {
    id: 'r1', date: '12 Apr 2026', place: 'Home · Dinner',
    title: 'Topic explored: Taste of Childhood',
    detail: 'Completed 3 of 4 opening questions with a grandparent.',
    type: 'topic',
  },
  {
    id: 'r2', date: '10 Apr 2026', place: 'Neighbourhood Walk',
    title: 'Browsed: Memories on the Road',
    detail: 'Viewed scenario cards and topic suggestions.',
    type: 'browse',
  },
  {
    id: 'r3', date: '6 Apr 2026', place: 'Online',
    title: 'Mood Board summary generated',
    detail: 'Weekly mood report preview.',
    type: 'report',
  },
  {
    id: 'r4', date: '28 Mar 2026', place: 'On the road',
    title: 'Topic saved: Snacks on the Road',
    detail: 'Bookmarked 1 deep-dive question.',
    type: 'topic',
  },
]

/** Helpers */
export function getScenarioById(id) { return scenarios.find(s => s.id === id) }
export function getTopicsByScenario(scenarioId) { return topics.filter(t => t.scenarioId === scenarioId) }
export function getTopicById(topicId) { return topics.find(t => t.id === topicId) }
export function getMoodById(id) { return moodTypes.find(m => m.id === id) }
