import { Button } from "@material-ui/core"

const ConceptResultPage = (props) => {
    const data = props.location.state.response
    console.log("Here is the prop!")
    console.log(data)

    const deconstructData = () => {
        return (
            data.map(function (item, index) {
                return (
                    Object.entries(item).map(([columnName, info]) => {
                        return (
                            <Button variant="contained" color="primary">
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