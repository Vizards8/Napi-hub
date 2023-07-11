package com.nz.napiinterface.controller;

import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.List;
import java.util.Random;


/**
 * @author Vizar
 */


@RestController
public class QuoteController {

    private List<String> quotes;

    public QuoteController() {
        quotes = new ArrayList<>();
        quotes.add("\"The secret of getting ahead is getting started.\" — Mark Twain");
        quotes.add("\"The future belongs to those who believe in the beauty of their dreams.\" - Eleanor Roosevelt");
        quotes.add("\"Success is not final, failure is not fatal: It is the courage to continue that counts.\" - Winston Churchill");
        quotes.add("\"Life is a long lesson in humility.\" - James M. Barrie");
        quotes.add("\"Strive not to be a success, but rather to be of value.\" - Albert Einstein");
        quotes.add("\"The work of art is a scream of freedom.\" - Christo");
        quotes.add("\"To make us love our country, our country ought to be lovely.\" - Edmund Burke");
        quotes.add("\"If you want to see the true measure of a man, watch how he treats his inferiors, not his equals.\" - J. K. Rowling");
        quotes.add("\"Success is a lousy teacher. It seduces smart people into thinking they can't lose.\" - Bill Gates");
        quotes.add("\"The most important thing is to try and inspire people so that they can be great in whatever they want to do.\" - Kobe Bryant");
        quotes.add("\"You have enemies? Good. That means you've stood up for something, sometime in your life.\" - Victor Hugo");
        quotes.add("\"Every great story seems to begin with a snake.\" - Nicolas Cage");
        quotes.add("\"Great things in business are never done by one person. They're done by a team of people.\" - Steve Jobs");
        quotes.add("\"If you fell down yesterday, stand up today.\" - H. G. Wells");
        quotes.add("\"One of the penalties for refusing to participate in politics is that you end up being governed by your inferiors.\" - Plato");
        quotes.add("\"I am not afraid of an army of lions led by a sheep; I am afraid of an army of sheep led by a lion.\" - Alexander the Great");
        quotes.add("\"Sir, my concern is not whether God is on our side; my greatest concern is to be on God's side, for God is always right.\" - Abraham Lincoln");
        quotes.add("\"The best and most beautiful things in the world cannot be seen or even touched - they must be felt with the heart.\" - Helen Keller");
        quotes.add("\"Quality is not an act, it is a habit.\" - Aristotle");
        quotes.add("\"It is easier to find men who will volunteer to die, than to find those who are willing to endure pain with patience.\" - Julius Caesar");
    }

    @GetMapping("/quote")
    public String getQuote() {
        // 返回随机 quote
        Random random = new Random();
        int randomIndex = random.nextInt(quotes.size());
        String quote = quotes.get(randomIndex);

        return quote;
    }
}

