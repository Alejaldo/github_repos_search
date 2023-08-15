import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["input", "results"];

  async search(event) {
    event.preventDefault();

    const url = "/search?q=" + this.inputTarget.value;
    const response = await fetch(url, { headers: { "Accept": "application/json" } });
    const repositories = await response.json();

    this.displayResult(repositories);
  }

  displayResult(repositories) {
    let html = '<table><thead><tr><th>Name</th><th>Full Name</th><th>Description</th><th>Owner</th><th>URL</th><th>Stargazers</th></tr></thead><tbody>'; // Added Stargazers in header
    repositories.forEach((repo) => {
      html += '<tr>';
      html += `<td>${repo.name}</td>`;
      html += `<td>${repo.full_name}</td>`;
      html += `<td>${repo.description}</td>`;
      html += `<td>${repo.owner.login}</td>`;
      html += `<td><a href="${repo.html_url}" target="_blank">${repo.html_url}</a></td>`;
      html += `<td>${repo.stargazers_count}</td>`;
      html += '</tr>';
    });
    html += '</tbody></table>';

    this.resultsTarget.innerHTML = html;
  }
}
