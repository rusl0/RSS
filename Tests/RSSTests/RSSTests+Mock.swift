@testable import RSS

extension RSSTests {
    var mock: RSSFeed {
        .init(
            channel: .init(
                title: "Iris",
                link: "http://www.iris.news/",
                description: "The one place for you daily news.",
                language: "en-us",
                copyright: "Copyright 2015, Iris News",
                pubDate: FeedDateFormatter(spec: .rfc822).date(from: "Sun, 16 Aug 2015 05:00:00 GMT"),
                lastBuildDate: FeedDateFormatter(spec: .rfc822).date(from: "Sun, 16 Aug 2015 18:18:55 GMT"),
                categories: [
                    .init(
                        text: "Media"
                    ),
                    .init(
                        text: "News/Media/Science",
                        attributes: .init(
                            domain: "dmoz"
                        )
                    ),
                ],
                image: .init(
                    url: "http://www.iris.news/image.jpg",
                    title: "Iris",
                    link: "http://www.iris.news/",
                    width: 64,
                    height: 192,
                    description: "Read the Iris news feed."
                ),
                skipHours: .init(
                    hours: [
                        0,
                        1,
                        2,
                        22,
                        23,
                    ]
                ),
                skipDays: .init(
                    days: [
                        .saturday, .sunday,
                    ]
                ),
                items: [
                    .init(
                        title: "Seventh Heaven! Ryan Hurls Another No Hitter",
                        link: "http://dallas.example.com/1991/05/02/nolan.htm",
                        description:
                            "I'm headed for France. I wasn't gonna go this year, but then last week \"Valley Girl\" came out and I said to myself, Joe Bob, you gotta get out of the country for a while.",
                        author: "jbb@dallas.example.com (Joe Bob Briggs)",
                        categories: [
                            .init(
                                text: "movies"
                            ),
                            .init(
                                text: "1983/V",
                                attributes: .init(
                                    domain: "rec.arts.movies.reviews"
                                )
                            ),
                        ],
                        comments: "http://dallas.example.com/feedback/1983/06/joebob.htm",
                        enclosure: [
                            .init(
                                attributes: .init(
                                    url: "http://dallas.example.com/joebob_050689.mp3",
                                    length: 24_986_239,
                                    type: "audio/mpeg"
                                )
                            )
                        ],
                        guid: "tag:dallas.example.com,4131:news",
                        pubDate: FeedDateFormatter(spec: .rfc822).date(from: "Fri, 05 Oct 2007 09:00:00 CST")
                    ),
                    .init(
                        title: "Seventh Heaven! Ryan Hurls Another No Hitter",
                        link: "http://dallas.example.com/1991/05/02/nolan.htm",
                        description:
                            "I'm headed for France. I wasn't gonna go this year, but then last week <a href=\"http://www.imdb.com/title/tt0086525/\">Valley Girl</a> came out and I said to myself, Joe Bob, you gotta get out of the country for a while.",
                        author: "jbb@dallas.example.com (Joe Bob Briggs)",
                        categories: [
                            .init(
                                text: "movies"
                            ),
                            .init(
                                text: "1983/V",
                                attributes: .init(
                                    domain: "rec.arts.movies.reviews"
                                )
                            ),
                        ],
                        comments: "http://dallas.example.com/feedback/1983/06/joebob.htm",
                        enclosure: [
                            .init(
                                attributes: .init(
                                    url: "http://dallas.example.com/joebob_050689.mp3",
                                    length: 24_986_239,
                                    type: "audio/mpeg"
                                )
                            )
                        ],
                        guid: "http://dallas.example.com/item/1234",
                        pubDate: FeedDateFormatter(spec: .rfc822).date(from: "Fri, 05 Oct 2007 09:00:00 CST")
                    ),
                ]
            )
        )
    }

    var simpleMock: RSSFeed {
        .init(
            channel:
                .init(
                    title: "Iris",
                    link: "http://www.iris.news/",
                    items: [
                        .init(
                            title: "Seventh Heaven! Ryan Hurls Another No Hitter",
                            link: "http://dallas.example.com/1991/05/02/nolan.htm"
                        ),
                        .init(
                            title: "Seventh Heaven! Ryan Hurls Another No Hitter",
                            link: "http://dallas.example.com/1991/05/02/nolan.htm"
                        ),
                    ]
                )
        )
    }
}
