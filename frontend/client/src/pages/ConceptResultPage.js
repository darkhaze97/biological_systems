import { Button } from "@material-ui/core"
import axios from "axios"

const ConceptResultPage = (props) => {
    const data = props.location.state.response
    console.log("Here is the prop!")
    console.log(data)

    const handleSubmit = (event, conceptInfo) => {
        event.preventDefault()
        var conceptInfoArray = conceptInfo.split("/")
        const id = Number(conceptInfoArray[0])

        axios.post("http://127.0.0.1:8080/concepts/results/specific", {id})
            .then((response) => {
                console.log(response)
                props.history.push('/concepts/results/specific', {response: response.data})
            })
            .catch((err) => {})
    }

    const deconstructData = () => {
        return (
            data.map(function (item, index) {
                return (
                    Object.entries(item).map(([columnName, info]) => {
                        return (
                            <Button onClick={(e) => handleSubmit(e, columnName)} variant="contained" color="primary">
                                {columnName}: {info}
                            </Button> 
                        )
                    })
                )
            })
        )
    }

    return (
        <div class="App">
            {deconstructData()}
        </div>
    )
}

export default ConceptResultPage;