local Translations = {
    error = {
        you_dont_have_the_ingredients_to_make_this = "you don\'t have the ingredients to make this!",
        something_went_wrong = 'something went wrong!',
        you_dont_have_that_much_on_you = "You don\'t have that much on you.",
        you_dont_have_an_item_on_you = "You don\'t have an item on you",
        must_not_be_a_negative_value = 'must not be a negative value.',
    },
    success = {
        you_made_some_moonshine_mash = 'you made some moonshine mash',
    },
    primary = {
        moonshinemash_destroyed = 'moonshine mash destroyed!',
    },
    menu = {
        close_menu = 'Close menu',
        mix = 'Mix [J]',
        pickup = 'pickup [R]',
        moonshinemash = '| moonshinemash |',
    },
    commands = {
            var = 'text goes here',
    },
    progressbar = {
            var = 'text goes here',
    },
    text = {
        xwheat_10xwater_10xcorn_and_5xginseng = '10 x Wheat 10 x Water 10 x Corn and 5 x Ginseng',
        sell = 'sell',
    }
}

Lang = Locale:new({
    phrases = Translations,
    warnOnMissing = true
})
