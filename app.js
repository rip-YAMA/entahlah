const scripts = [
  {
    title: "Universal Autofarm Script",
    desc: "Works on multiple games",
    time: "2 hours ago"
  },
  {
    title: "MM2 ESP + Aimbot",
    desc: "Highlight players",
    time: "5 hours ago"
  },
  {
    title: "Blox Fruits Auto Farm",
    desc: "Level & quest farm",
    time: "1 day ago"
  },
  {
    title: "Anime Fighters Script",
    desc: "Auto click & upgrade",
    time: "2 days ago"
  }
];

const list = document.getElementById("list");
const search = document.getElementById("search");
const loading = document.getElementById("loading");
const content = document.getElementById("content");

function render(data) {
  list.innerHTML = "";
  data.forEach(item => {
    list.innerHTML += `
      <div class="card">
        <h3>${item.title}</h3>
        <p>${item.desc}</p>
        <span>${item.time}</span>
      </div>
    `;
  });
}

search.addEventListener("input", e => {
  const q = e.target.value.toLowerCase();
  render(
    scripts.filter(s =>
      s.title.toLowerCase().includes(q)
    )
  );
});

/* FAKE LOADING */
setTimeout(() => {
  loading.style.display = "none";
  content.classList.remove("hidden");
  render(scripts);
}, 1500);