document.getElementById('search-movie').addEventListener('click', function() {
    const title = document.getElementById('movie-title').value;
    if (title === '') return;

    const apiKey = process.env.TMDB_KEY;
    const url = `https://www.omdbapi.com/?t=${title}&apikey=${apiKey}`;

    fetch(url)
        .then(response => response.json())
        .then(data => {
            const movieDetails = document.getElementById('movie-details');
            if (data.Response === 'True') {
                movieDetails.innerHTML = `
                    <h2>${data.Title}</h2>
                    <img src="${data.Poster}" alt="${data.Title}">
                    <p><strong>Year:</strong> ${data.Year}</p>
                    <p><strong>Genre:</strong> ${data.Genre}</p>
                    <p><strong>Plot:</strong> ${data.Plot}</p>
                `;
            } else {
                movieDetails.innerHTML = `<p>${data.Error}</p>`;
            }
        })
        .catch(error => {
            console.error('Error fetching movie data:', error);
        });
});
