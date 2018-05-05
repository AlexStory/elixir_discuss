import { Socket } from "phoenix"

let socket = new Socket("/socket", { params: { token: window.userToken } })

socket.connect()

const createSocket = (id) => {
    let channel = socket.channel(`comments:${id}`, {})
    channel.join()
        .receive("ok", resp => { renderComments(resp.comments) })
        .receive("error", resp => { console.log("Unable to join", resp) })

    document.querySelector('button').addEventListener('click', () => {
        const content = document.querySelector('textarea').value

        channel.push('comment:add', { content })
    })
    channel.on("new_topic", resp => addComment(resp.comment))
    channel.on("ok", resp => console.log(resp))
}

function addComment(comment) {
    let ul = document.querySelector('.comment-list')
    let li = document.createElement('li')
    li.innerText = comment.body
    li.classList.add('collection-item')
    let div = document.createElement('div')
    div.classList.add('secondary-content')
    div.innerText = comment.user.email
    li.appendChild(div)
    ul.appendChild(li)
}

function renderComments(comments) {
    let ul = document.querySelector('.comment-list')
    comments.forEach(comment => {
        let li = document.createElement('li')
        li.innerText = comment.body
        li.classList.add('collection-item')
        let div = document.createElement('div')
        div.classList.add('secondary-content')
        div.innerText = comment.user.email
        li.appendChild(div)
        ul.appendChild(li)
    });
}

window.createSocket = createSocket
export default socket