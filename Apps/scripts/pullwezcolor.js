const name="glacier"
const colors = []
const rgb2hex = (rgb) => `#${rgb.match(/^rgb\((\d+),\s*(\d+),\s*(\d+)\)$/).slice(1).map(n => parseInt(n, 10).toString(16).padStart(2, '0')).join('')}`
for (let i = 0; i < 16; ++i) {
    let x = document.querySelector(`#${name}-player .fg-${i}`);
    let rgb = window.getComputedStyle(x, null).getPropertyValue( "color" );
    colors.push(rgb2hex(rgb))
}
console.log(colors)
