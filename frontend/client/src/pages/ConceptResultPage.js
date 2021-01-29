

const ConceptResultPage = (props) => {
    const data = props.location.state.response
    console.log("Here is the prop!")
    console.log(data)

    return (
        <div class="App">
            Hiya
        </div>
    )
}

export default ConceptResultPage;