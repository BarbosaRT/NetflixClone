import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:netflix/core/api.dart';
import 'package:netflix/core/api/http_interface.dart';

import '../errors/content_error.dart';
import '../models/content_detail_model.dart';
import '../models/content_response_model.dart';

import 'package:http/http.dart' as http;

const con = {
  "page": 1,
  "results": [
    {
      "adult": false,
      "backdrop_path": "/vvObT0eIWGlArLQx3K5wZ0uT812.jpg",
      "genre_ids": [28, 12, 14],
      "id": 616037,
      "original_language": "en",
      "original_title": "Thor: Love and Thunder",
      "overview":
          "After his retirement is interrupted by Gorr the God Butcher, a galactic killer who seeks the extinction of the gods, Thor Odinson enlists the help of King Valkyrie, Korg, and ex-girlfriend Jane Foster, who now inexplicably wields Mjolnir as the Relatively Mighty Girl Thor. Together they embark upon a harrowing cosmic adventure to uncover the mystery of the God Butcher’s vengeance and stop him before it’s too late.",
      "popularity": 8104.31,
      "poster_path": "/pIkRyD18kl4FhoCNQuWxWu5cBLM.jpg",
      "release_date": "2022-07-06",
      "title": "Thor: Love and Thunder",
      "video": false,
      "vote_average": 6.8,
      "vote_count": 2108
    },
    {
      "adult": false,
      "backdrop_path": "/ugS5FVfCI3RV0ZwZtBV3HAV75OX.jpg",
      "genre_ids": [16, 878, 28],
      "id": 610150,
      "original_language": "ja",
      "original_title": "ドラゴンボール超 スーパーヒーロー",
      "overview":
          "The Red Ribbon Army, an evil organization that was once destroyed by Goku in the past, has been reformed by a group of people who have created new and mightier Androids, Gamma 1 and Gamma 2, and seek vengeance against Goku and his family.",
      "popularity": 7517.196,
      "poster_path": "/rugyJdeoJm7cSJL1q4jBpTNbxyU.jpg",
      "release_date": "2022-06-11",
      "title": "Dragon Ball Super: Super Hero",
      "video": false,
      "vote_average": 7.2,
      "vote_count": 196
    },
    {
      "adult": false,
      "backdrop_path": "/7ZO9yoEU2fAHKhmJWfAc2QIPWJg.jpg",
      "genre_ids": [53, 28],
      "id": 766507,
      "original_language": "en",
      "original_title": "Prey",
      "overview":
          "When danger threatens her camp, the fierce and highly skilled Comanche warrior Naru sets out to protect her people. But the prey she stalks turns out to be a highly evolved alien predator with a technically advanced arsenal.",
      "popularity": 6874.014,
      "poster_path": "/ujr5pztc1oitbe7ViMUOilFaJ7s.jpg",
      "release_date": "2022-08-02",
      "title": "Prey",
      "video": false,
      "vote_average": 8,
      "vote_count": 3234
    },
    {
      "adult": false,
      "backdrop_path": "/9n5e1vToDVnqz3hW10Jdlvmzpo0.jpg",
      "genre_ids": [28, 18],
      "id": 361743,
      "original_language": "en",
      "original_title": "Top Gun: Maverick",
      "overview":
          "After more than thirty years of service as one of the Navy’s top aviators, and dodging the advancement in rank that would ground him, Pete “Maverick” Mitchell finds himself training a detachment of TOP GUN graduates for a specialized mission the likes of which no living pilot has ever seen.",
      "popularity": 4724.785,
      "poster_path": "/62HCnUTziyWcpDaBO2i1DX17ljH.jpg",
      "release_date": "2022-05-24",
      "title": "Top Gun: Maverick",
      "video": false,
      "vote_average": 8.4,
      "vote_count": 2978
    },
    {
      "adult": false,
      "backdrop_path": "/nmGWzTLMXy9x7mKd8NKPLmHtWGa.jpg",
      "genre_ids": [16, 12, 35, 14],
      "id": 438148,
      "original_language": "en",
      "original_title": "Minions: The Rise of Gru",
      "overview":
          "A fanboy of a supervillain supergroup known as the Vicious 6, Gru hatches a plan to become evil enough to join them, with the backup of his followers, the Minions.",
      "popularity": 3747.877,
      "poster_path": "/wKiOkZTN9lUUUNZLmtnwubZYONg.jpg",
      "release_date": "2022-06-29",
      "title": "Minions: The Rise of Gru",
      "video": false,
      "vote_average": 7.7,
      "vote_count": 1658
    },
    {
      "adult": false,
      "backdrop_path": "/jauI01vUIkPA0xVsamGj0Gs1nNL.jpg",
      "genre_ids": [12, 28, 878],
      "id": 507086,
      "original_language": "en",
      "original_title": "Jurassic World Dominion",
      "overview":
          "Four years after Isla Nublar was destroyed, dinosaurs now live—and hunt—alongside humans all over the world. This fragile balance will reshape the future and determine, once and for all, whether human beings are to remain the apex predators on a planet they now share with history’s most fearsome creatures.",
      "popularity": 3733.899,
      "poster_path": "/kAVRgw7GgK1CfYEJq8ME6EvRIgU.jpg",
      "release_date": "2022-06-01",
      "title": "Jurassic World Dominion",
      "video": false,
      "vote_average": 7.1,
      "vote_count": 3061
    },
    {
      "adult": false,
      "backdrop_path": "/xfNHRI2f5kHGvogxLd0C5sB90L7.jpg",
      "genre_ids": [16, 28, 10751, 878, 35],
      "id": 539681,
      "original_language": "en",
      "original_title": "DC League of Super-Pets",
      "overview":
          "When Superman and the rest of the Justice League are kidnapped, Krypto the Super-Dog must convince a rag-tag shelter pack - Ace the hound, PB the potbellied pig, Merton the turtle and Chip the squirrel - to master their own newfound powers and help him rescue the superheroes.",
      "popularity": 3307.165,
      "poster_path": "/r7XifzvtezNt31ypvsmb6Oqxw49.jpg",
      "release_date": "2022-07-27",
      "title": "DC League of Super-Pets",
      "video": false,
      "vote_average": 7.5,
      "vote_count": 222
    },
    {
      "adult": false,
      "backdrop_path": "/5L6RPHHUFlsliTqKRmUxFnIkXpR.jpg",
      "genre_ids": [28, 14, 27, 35],
      "id": 755566,
      "original_language": "en",
      "original_title": "Day Shift",
      "overview":
          "An LA vampire hunter has a week to come up with the cash to pay for his kid's tuition and braces. Trying to make a living these days just might kill him.",
      "popularity": 2915.738,
      "poster_path": "/bI7lGR5HuYlENlp11brKUAaPHuO.jpg",
      "release_date": "2022-08-10",
      "title": "Day Shift",
      "video": false,
      "vote_average": 6.9,
      "vote_count": 711
    },
    {
      "adult": false,
      "backdrop_path": "/AfvIjhDu9p64jKcmohS4hsPG95Q.jpg",
      "genre_ids": [27, 53, 14],
      "id": 756999,
      "original_language": "en",
      "original_title": "The Black Phone",
      "overview":
          "Finney Blake, a shy but clever 13-year-old boy, is abducted by a sadistic killer and trapped in a soundproof basement where screaming is of little use. When a disconnected phone on the wall begins to ring, Finney discovers that he can hear the voices of the killer’s previous victims. And they are dead set on making sure that what happened to them doesn’t happen to Finney.",
      "popularity": 2851.056,
      "poster_path": "/lr11mCT85T1JanlgjMuhs9nMht4.jpg",
      "release_date": "2022-06-22",
      "title": "The Black Phone",
      "video": false,
      "vote_average": 7.9,
      "vote_count": 2177
    },
    {
      "adult": false,
      "backdrop_path": "/bL7VIHQ4Nl0hZMw8ZeX6byoEEZJ.jpg",
      "genre_ids": [878, 35, 28],
      "id": 1006851,
      "original_language": "en",
      "original_title": "Office Invasion",
      "overview":
          "Three friends come together to defend their valuable mining company from…aliens?! What could possibly go wrong?",
      "popularity": 2823.988,
      "poster_path": "/kDC9Q3kiVaxrJijaGeZ8ZB2ZoiX.jpg",
      "release_date": "2022-08-10",
      "title": "Office Invasion",
      "video": false,
      "vote_average": 5.9,
      "vote_count": 60
    },
    {
      "adult": false,
      "backdrop_path": "/3VQj6m0I6gkuRaljmhNZl0XR3by.jpg",
      "genre_ids": [16, 12, 35, 14],
      "id": 585511,
      "original_language": "en",
      "original_title": "Luck",
      "overview":
          "Suddenly finding herself in the never-before-seen Land of Luck, the unluckiest person in the world must unite with the magical creatures there to turn her luck around.",
      "popularity": 2604.057,
      "poster_path": "/1HOYvwGFioUFL58UVvDRG6beEDm.jpg",
      "release_date": "2022-08-05",
      "title": "Luck",
      "video": false,
      "vote_average": 8.1,
      "vote_count": 565
    },
    {
      "adult": false,
      "backdrop_path": "/6cpRpfD3isvluFwXDGSiDVyibPJ.jpg",
      "genre_ids": [10749, 18],
      "id": 829560,
      "original_language": "pl",
      "original_title": "Kolejne 365 dni",
      "overview":
          "Laura and Massimo's relationship hangs in the balance as they try to overcome trust issues while a tenacious Nacho works to push them apart.",
      "popularity": 2166.868,
      "poster_path": "/dlyzCeI8wojBsUWdkNdO5AXtmZq.jpg",
      "release_date": "2022-08-19",
      "title": "The Next 365 Days",
      "video": false,
      "vote_average": 6.9,
      "vote_count": 309
    },
    {
      "adult": false,
      "backdrop_path": "/sS4MadD7pKMt251vKxdJo2YrkYP.jpg",
      "genre_ids": [10749, 18],
      "id": 744276,
      "original_language": "en",
      "original_title": "After Ever Happy",
      "overview":
          "As a shocking truth about a couple's families emerges, the two lovers discover they are not so different from each other. Tessa is no longer the sweet, simple, good girl she was when she met Hardin — any more than he is the cruel, moody boy she fell so hard for.",
      "popularity": 2100.07,
      "poster_path": "/moogpu8rNkEjTgFyLXwhPghft5w.jpg",
      "release_date": "2022-08-24",
      "title": "After Ever Happy",
      "video": false,
      "vote_average": 6.5,
      "vote_count": 28
    },
    {
      "adult": false,
      "backdrop_path": "/iGHFjqxH5c8zRibnZbh9qEYTBho.jpg",
      "genre_ids": [28],
      "id": 1008779,
      "original_language": "es",
      "original_title": "La Princesa",
      "overview":
          "Refusing to marry a drug lord, Grecia is determined to pay her father's debt herself. To earn the money, she decides to bet in the Sinaloa palenques, where she meets Armando. He is immediately captivated by her beauty and fearless attitude. But, little does he know that falling for her will be his most dangerous endeavor. Based on the famous corrido hit \"La Princesa\", by Alfredo Ríos \"El Komander\".",
      "popularity": 2047.244,
      "poster_path": "/ksxiXqwPuEjh3gct1zUpyzNoQFt.jpg",
      "release_date": "2022-08-05",
      "title": "The princess",
      "video": false,
      "vote_average": 7.8,
      "vote_count": 18
    },
    {
      "adult": false,
      "backdrop_path": "/wcKFYIiVDvRURrzglV9kGu7fpfY.jpg",
      "genre_ids": [14, 28, 12],
      "id": 453395,
      "original_language": "en",
      "original_title": "Doctor Strange in the Multiverse of Madness",
      "overview":
          "Doctor Strange, with the help of mystical allies both old and new, traverses the mind-bending and dangerous alternate realities of the Multiverse to confront a mysterious new adversary.",
      "popularity": 1863.111,
      "poster_path": "/9Gtg2DzBhmYamXBS1hKAhiwbBKS.jpg",
      "release_date": "2022-05-04",
      "title": "Doctor Strange in the Multiverse of Madness",
      "video": false,
      "vote_average": 7.5,
      "vote_count": 5486
    },
    {
      "adult": false,
      "backdrop_path": "/nW5fUbldp1DYf2uQ3zJTUdachOu.jpg",
      "genre_ids": [16, 878, 12, 28, 10751],
      "id": 718789,
      "original_language": "en",
      "original_title": "Lightyear",
      "overview":
          "Legendary Space Ranger Buzz Lightyear embarks on an intergalactic adventure alongside a group of ambitious recruits and his robot companion Sox.",
      "popularity": 1754.245,
      "poster_path": "/ox4goZd956BxqJH6iLwhWPL9ct4.jpg",
      "release_date": "2022-06-15",
      "title": "Lightyear",
      "video": false,
      "vote_average": 7.3,
      "vote_count": 1873
    },
    {
      "adult": false,
      "backdrop_path": "/1U5zz2Jvt2L7hXHf1ZN1n74Zx8j.jpg",
      "genre_ids": [28, 53, 80],
      "id": 769636,
      "original_language": "es",
      "original_title": "Código Emperador",
      "overview":
          "Follows Juan, an agent working for the intelligence services, who also reports to a parallel unit involved in illegal activities.",
      "popularity": 1625.978,
      "poster_path": "/8VjVLMiPm598Kg6XmKk5m1fz0p7.jpg",
      "release_date": "2022-03-18",
      "title": "Code Name: Emperor",
      "video": false,
      "vote_average": 5.8,
      "vote_count": 69
    },
    {
      "adult": false,
      "backdrop_path": "/14QbnygCuTO0vl7CAFmPf1fgZfV.jpg",
      "genre_ids": [28, 12, 878],
      "id": 634649,
      "original_language": "en",
      "original_title": "Spider-Man: No Way Home",
      "overview":
          "Peter Parker is unmasked and no longer able to separate his normal life from the high-stakes of being a super-hero. When he asks for help from Doctor Strange the stakes become even more dangerous, forcing him to discover what it truly means to be Spider-Man.",
      "popularity": 1570.276,
      "poster_path": "/uJYYizSuA9Y3DCs0qS4qWvHfZg4.jpg",
      "release_date": "2021-12-15",
      "title": "Spider-Man: No Way Home",
      "video": false,
      "vote_average": 8,
      "vote_count": 14845
    },
    {
      "adult": false,
      "backdrop_path": "/8wwXPG22aNMpPGuXnfm3galoxbI.jpg",
      "genre_ids": [28, 12, 10751, 35],
      "id": 675353,
      "original_language": "en",
      "original_title": "Sonic the Hedgehog 2",
      "overview":
          "After settling in Green Hills, Sonic is eager to prove he has what it takes to be a true hero. His test comes when Dr. Robotnik returns, this time with a new partner, Knuckles, in search for an emerald that has the power to destroy civilizations. Sonic teams up with his own sidekick, Tails, and together they embark on a globe-trotting journey to find the emerald before it falls into the wrong hands.",
      "popularity": 1564.055,
      "poster_path": "/6DrHO1jr3qVrViUO6s6kFiAGM7.jpg",
      "release_date": "2022-03-30",
      "title": "Sonic the Hedgehog 2",
      "video": false,
      "vote_average": 7.7,
      "vote_count": 2883
    },
    {
      "adult": false,
      "backdrop_path": "/noCgyITVoRxC3huC9zSOQq23sVr.jpg",
      "genre_ids": [80, 53, 18],
      "id": 821420,
      "original_language": "en",
      "original_title": "Catch the Fair One",
      "overview":
          "A Native American boxer embarks on the fight of her life when she goes in search of her missing sister.",
      "popularity": 1525.765,
      "poster_path": "/35QvPu5nOGlzDIGOdvtRNNkfjLZ.jpg",
      "release_date": "2022-02-11",
      "title": "Catch the Fair One",
      "video": false,
      "vote_average": 6.2,
      "vote_count": 20
    }
  ],
  "total_pages": 34908,
  "total_results": 698149
};

class ContentRepository {
  final Dio dio = Dio(kDioOptions);
  late final HttpInterface httpInterface;

  ContentRepository() {
    httpInterface = HttpImpl(client: http.Client(), headers: kHeaders);
  }

  Future<Either<ContentError, ContentResponseModel>> fetchAllMovies(
      int page) async {
    try {
      final response = await httpInterface.get('/movie/popular?page=$page');
      final model = ContentResponseModel.fromMap(response);
      return Right(model);
    } on DioError catch (error) {
      if (error.response != null) {
        return Left(error.response!.data['status_message']);
      } else {
        return Left(MovieRepositoryError(kServerError));
      }
    } on Exception catch (error) {
      return Left(MovieRepositoryError(error.toString()));
    }
  }

  Future<Either<ContentError, ContentDetailModel>> fetchContentById(
      int id) async {
    try {
      final response = await httpInterface.get('/movie/$id');
      final model = ContentDetailModel.fromMap(response.data);
      return Right(model);
    } on DioError catch (error) {
      if (error.response != null) {
        return Left(
            MovieRepositoryError(error.response!.data['status_message']));
      } else {
        return Left(MovieRepositoryError(kServerError));
      }
    } on Exception catch (error) {
      return Left(MovieRepositoryError(error.toString()));
    }
  }
}
