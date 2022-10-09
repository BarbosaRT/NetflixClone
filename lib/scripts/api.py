import os
import random
import time
from PIL import Image
import requests
import json
import pytube
import unidecode

API_KEY = '456a2c767a26c3bd89a076ab4ec8f89b'
DELAY = 0.0
POSTER = 'assets/data/posters/breaking_bad_poster.jpg'
TRAILER = 'assets/data/trailers/breaking_bad_trailer.mp4'
GENRES = ["Suspense No Ar",
          "Empolgante",
          "Excêntricos",
          "Realistas",
          "Esperto",
          "Adrenalina Pura",
          "Impacto visual",
          "Espirituosos", ]
LOGO = Image.open('./logo.png').convert('RGBA')
LINK = 'https://www.youtube.com/watch?v=SPqNBE2xTUI'


class ContentModel:
    def __init__(self, rating: int = 5, trailer: str = '', poster: str = '', age: int = 0, detail: str = '',
                 backdrop: str = 'assets/data/backdrops/breaking_bad_backdrop.jpg', tags: list = (),
                 logo: str = 'assets/data/logos/breaking_bad_logo.png', title: str = '', overview: str = ''):
        self.rating = rating
        self.trailer = trailer
        self.poster = poster
        self.backdrop = backdrop
        self.tags = list(tags)
        self.age = age
        self.detail = detail
        self.logo = logo
        self.title = title
        self.overview = overview

    def to_json(self):
        return {
            'rating': int(self.rating if str(self.rating).isdigit() else 80),
            'trailer': self.trailer,
            'poster': self.poster,
            'backdrop': self.backdrop,
            'tags': list(self.tags),
            'age': int(self.age if str(self.age).isdigit() else 0),
            'detail': self.detail,
            'logo': self.logo,
            'title': self.title,
            'overview': self.overview
        }


def treat_str(string: str):
    output = string.replace('/', '').replace(':', '')
    return unidecode.unidecode(output)


def save_image(p: str, title: str, logo: bool = False):
    img_data = requests.get(p).content
    file_name = treat_str('_'.join(str(title).split(
        ' ')[0:2])) + str(random.randint(0, 69420)) + '_poster'
    if os.path.exists(f'./posters/{file_name}.png'):
        return 'assets/data/posters/' + file_name + '.png'
    with open(f'./posters/{file_name}.png', 'wb') as handler:
        handler.write(img_data)

    print(f'SAVING IMAGE {title}')
    # adds logo
    if logo:
        print('ADDING LOGO')
        image1 = Image.open(f'./posters/{file_name}.png').convert('RGBA')
        new_image = Image.new('RGBA', image1.size, (250, 250, 250, 0))
        new_image.paste(image1, (0, 0))
        new_image.paste(LOGO, (10, 10), LOGO)
        new_image.save(f'./posters/{file_name}.png', "PNG")

    poster = 'assets/data/posters/' + file_name + '.png'
    return poster


def save_trailer(title: str, link: str):
    trailer = treat_str('_'.join(str(title).split(
        ' ')[0:1])) + str(random.randint(0, 69420)) + '_trailer.mp4'
    if os.path.exists(f'./trailers/{trailer}'):
        return f'assets/data/trailers/{trailer}'
    yt = pytube.YouTube(link if link != '' else LINK)
    stream_id = 22
    print(f'SAVING TRAILER - {title}')
    try:
        if link == '':
            raise Exception()
        for stream in yt.streams.filter(file_extension='mp4', progressive=True):
            stream_id = stream.itag
            if stream.resolution == '480p':
                break
        stream = yt.streams.get_by_itag(stream_id)
        stream.download(
            output_path='./trailers/',
            filename=trailer)
        trailer = f'assets/data/trailers/{trailer}'
    except Exception:
        stream_id = 22
        s = pytube.Search(f'{treat_str(title)} trailer dublado')
        yt = s.results[0]
        print('TRAILER NOT FOUND, TRYING SEARCH')
        print(f'RESULT FOUND - {yt.title}: {yt.watch_url}')
        try:
            for stream in yt.streams.filter(file_extension='mp4', progressive=True):
                stream_id = stream.itag
                if stream.resolution == '480p':
                    break
            stream = yt.streams.get_by_itag(stream_id)
            stream.download(
                output_path='./trailers/',
                filename=trailer)
            trailer = f'assets/data/trailers/{trailer}'
        except Exception:
            print('TRAILER FAILED USING PLACEHOLDER')
            trailer = TRAILER
    return trailer


def get_tv(page: int = 1):
    response = requests.get(
        f'https://api.themoviedb.org/4/discover/tv?api_key={API_KEY}&language=pt-BR&page={page}&with_watch_providers=8&watch_region=BR')
    time.sleep(DELAY)
    data = response.json().get('results')
    output = []
    if data:
        for k in range(0, len(data)):
            i = data[k]
            tv_id = i.get('id')
            tv_response = requests.get(
                f'https://api.themoviedb.org/3/tv/{tv_id}?api_key={API_KEY}&language=pt-BR&include_image_language=en,pt&append_to_response=release_dates,videos,images')
            time.sleep(DELAY)
            tv_data = tv_response.json()

            rating = int(i.get('vote_average') * 10)

            title = i.get('name')

            tv_genres = tv_data.get('genres')
            genres = []
            translations = {'Action & Adventure': 'Ação e Aventura',
                            'Sci-Fi & Fantasy': 'Sci-Fi e Fantasia'}
            for g in tv_genres:
                genre = g.get('name')
                if genre in ['Action & Adventure', 'Sci-Fi & Fantasy']:
                    genre = translations[genre]
                genres.append(genre)
            if len(genres) < 3:
                genres = genres + random.sample(GENRES, k=3 - len(genres))
            elif random.randint(0, 3) > 1:
                aux = genres[0:4]
                aux.insert(random.randint(0, 2),
                           GENRES[random.randint(0, len(GENRES) - 1)])
                genres = aux[0:3]
            else:
                genres = genres[0:3]

            details = tv_data.get('number_of_seasons')
            detail = str(details) + \
                (' Temporadas' if details > 1 else ' Temporada')

            age_response = requests.get(
                f'https://api.themoviedb.org/3/tv/{tv_id}/content_ratings?api_key={API_KEY}&language=pt-BR')
            time.sleep(DELAY)
            age_data = age_response.json().get('results')
            age = 0
            for a in age_data:
                age_rating = str(a.get('rating'))
                if not age_rating.isdigit():
                    continue
                country = a.get('iso_3166_1')
                age = int(age_rating)
                if country == 'BR':
                    break
            if age == '':
                age = 0

            # poster -------------------------------------------------------------------- #
            only_request = requests.get(
                f'https://api.themoviedb.org/3/tv/{tv_id}/watch/providers?api_key={API_KEY}&language=pt-BR')
            only_data = only_request.json().get('results')
            if only_data.get('BR') is not None:
                only_on_netflix = len(only_data.get('BR').get('flatrate')) == 1
            elif only_data.get('US') is not None:
                only_on_netflix = len(only_data.get('US').get('flatrate')) == 1
            else:
                only_on_netflix = False

            poster = f'https://www.themoviedb.org/t/p/w400{i.get("backdrop_path")}'
            if str(i.get("backdrop_path")) == '':
                poster = POSTER
            else:
                posters_data = tv_data.get('images')
                for b in posters_data.get('backdrops'):
                    poster = f'https://www.themoviedb.org/t/p/w400{b.get("file_path")}'
                    if b.get('iso_639_1') == 'pt':
                        break
                poster = save_image(poster, title, only_on_netflix)

            # trailer ---------------------------------------------------------------------------------------------- #
            trailer_data = tv_data.get('videos').get('results')
            if len(trailer_data) != 0:
                if trailer_data[0].get('site') == 'YouTube':
                    trailer = save_trailer(
                        title=title, link='https://www.youtube.com/watch?v=' + trailer_data[0].get('key'))
                else:
                    trailer = save_trailer(title=title, link='')
            else:
                trailer = save_trailer(title=title, link='')
            print(f'{k + 1}/{len(data)} rating={rating}, age={age}, detail={detail}, title={title}, tags={genres}, poster={poster}, trailer={trailer}')
            content = ContentModel(rating=rating, age=age, detail=detail, title=title, tags=genres, poster=poster,
                                   trailer=trailer)
            output.append(content)
    return output


def get_movie(page: int = 0):
    response = requests.get(
        f'https://api.themoviedb.org/4/discover/movie?api_key={API_KEY}&language=pt-BR&page={page}&with_watch_providers=8&watch_region=BR&sort_by=vote_count.desc')
    time.sleep(DELAY)
    data = response.json().get('results')
    output = []
    if data:
        for k in range(0, len(data)):
            i = data[k]
            movie_id = i.get('id')
            movie_response = requests.get(
                f'https://api.themoviedb.org/3/movie/{movie_id}?api_key={API_KEY}&language=pt-BR&include_image_language=en,pt&append_to_response=release_dates,videos,images')
            movie_data = movie_response.json()

            # title -------------------------------------------------------------------- #
            title = i.get('title')

            # rating -------------------------------------------------------------------- #
            rating = int(i.get('vote_average') * 10)

            # poster -------------------------------------------------------------------- #
            only_request = requests.get(
                f'https://api.themoviedb.org/3/movie/{movie_id}/watch/providers?api_key={API_KEY}&language=pt-BR')
            only_data = only_request.json().get('results')
            if only_data.get('BR') is not None:
                only_on_netflix = len(only_data.get('BR').get('flatrate')) == 1
            elif only_data.get('US') is not None:
                only_on_netflix = len(only_data.get('US').get('flatrate')) == 1
            else:
                only_on_netflix = False

            poster = f'https://www.themoviedb.org/t/p/w400{i.get("backdrop_path")}'
            if str(i.get("backdrop_path")) == '':
                poster = POSTER
            else:
                posters_data = movie_data.get('images')
                for b in posters_data.get('backdrops'):
                    poster = f'https://www.themoviedb.org/t/p/w400{b.get("file_path")}'
                    if b.get('iso_639_1') == 'pt':
                        break
                poster = save_image(poster, title, only_on_netflix)

            # age ------------------------------------------------------------------------ #
            age_data = movie_data.get('release_dates').get('results')
            age = 0
            for a in age_data:
                if a.get('iso_3166_1') == 'BR':
                    aux = a.get('release_dates')[0].get('certification')
                    age = aux if aux != 'L' else 0

            # tags ------------------------------------------------------------------------ #
            genres = []
            for g in movie_data.get('genres'):
                genres.append(g.get('name'))
            if len(genres) < 3:
                genres = genres + random.choices(GENRES, k=3 - len(genres))
            elif random.randint(0, 3) > 1:
                aux = genres[0:4]
                aux.insert(random.randint(0, 2),
                           GENRES[random.randint(0, len(GENRES) - 1)])
                genres = aux[0:3]
            else:
                genres = genres[0:3]

            # details ---------------------------------------------------------------------- #
            runtime = int(movie_data.get('runtime'))
            detail = str(runtime) + 'min'
            if runtime >= 60:
                detail = str(runtime // 60) + 'h ' + \
                    str(runtime - (runtime // 60) * 60) + 'min'

            # trailer ---------------------------------------------------------------------------------------------- #
            trailer_data = movie_data.get('videos').get('results')
            if len(trailer_data) != 0:
                if trailer_data[0].get('site') == 'YouTube':
                    trailer = save_trailer(
                        title=title, link='https://www.youtube.com/watch?v=' + trailer_data[0].get('key'))
                else:
                    trailer = save_trailer(title=title, link='')
            else:
                trailer = save_trailer(title=title, link='')

            print(
                f'{k + 1}/{len(data)} rating={rating}, age={age}, detail={detail}, title={title}, tags={genres}, poster={poster}, trailer={trailer}')
            content = ContentModel(rating=rating, age=age, detail=detail, title=title, tags=genres, poster=poster,
                                   trailer=trailer)
            output.append(content)
    return output


def main():
    enable_tv_show = True
    enable_movies = True

    if not os.path.exists('./posters'):
        os.mkdir('./posters')
    if not os.path.exists('./trailers'):
        os.mkdir('./trailers')

    pages = {}
    if os.path.exists('contents.json'):
        with open('contents.json', 'r') as openfile:
            pages = json.load(openfile)

    for i in range(34, 37):
        random.seed(i)
        tv_shows = []
        if enable_tv_show:
            for p in range(i, i + 1):
                result = get_tv(p)
                for r in result:
                    tv_shows.append(r)

        movies = []
        if enable_movies:
            for p in range(i, i + 1):
                result = get_movie(p)
                for r in result:
                    movies.append(r)

        global_tv = 0
        global_movie = 0
        total_movies = 0
        page = {}
        for p in range(0, 40):
            content = ContentModel()
            choose = random.randint(0, 2)
            if (choose > 1 and global_movie - 2 < len(movies) - 1 and total_movies < 20) or global_tv - 2 >= len(tv_shows) - 2:
                content = movies[global_movie]
                global_movie += 1
                total_movies += 1
            elif global_tv - 2 < len(tv_shows) - 2:
                content = tv_shows[global_tv]
                global_tv += 1
            page[str(content.title)] = content.to_json()
        pages[str(i)] = page
        print(f'PAGE {i}: ')
        print(page)

        # Serializing json
        json_object = json.dumps(pages, indent=4)

        with open("contents.json", "w") as outfile:
            outfile.write(json_object)


if __name__ == '__main__':
    main()
