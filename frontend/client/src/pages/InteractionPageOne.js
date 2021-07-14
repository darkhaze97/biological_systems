import React from "react";
import axios from "axios";
import { Button, TextField, Select, FormControl, MenuItem, Menu, InputLabel } from "@material-ui/core"

const InteractionPage = (props) => {

    var entityTypesArray = JSON.parse(localStorage.getItem("entityTypes"));


    const [values, setValues] = React.useState({
        entity1: '',
        entity2: '',
    })

    const [types, setTypes] = React.useState({
        type1: 'Any',
        type2: 'Any',
    });

    const handleChange = name => event => {
        setValues({ ...values, [name]: event.target.value });
    }

    const handleTypeChange = event => {
        const name = event.target.name
        setTypes({ ...types, [name]: event.target.value})
    }

    const createDropdowns = () => {
        return (         
            entityTypesArray.map( function (item, index) {
              //  console.log(item)
                return (
                    <MenuItem value={item}>
                        {item}
                    </MenuItem>
                )
            })
        )
    }

    const handleSubmit = (event) => {
        event.preventDefault()
        
        axios.post("http://127.0.0.1:8080/interactions/results/all", {...values, ...types})
            .then((response) => {
                console.log(response)
                props.history.push('/interactions/results/all', {response: response.data})
            })
            .catch((err) => {})
    }

    console.log("I have reached here.")

    return (
        <div class="App">
            <header>
                <h3>
                    Interactions between entities
                </h3>
            </header>
            <form onSubmit={handleSubmit}>
                <TextField 
                    label="Entity 1"
                    variant="outlined"
                    type="text" 
                    id="entity1" 
                    name="entity1" 
                    value={values.molecule1} 
                    onChange={handleChange("entity1")}
                /><br></br>     
                <FormControl style={{minWidth: 200}}>
                    <InputLabel id="type1">Entity 1 Type</InputLabel>
                    <Select
                     labelId="type1"
                     id="type1"
                     value={types.type1}
                     onChange={handleTypeChange}
                     inputProps={{name: 'type1'}}
                     >
                        <MenuItem value={"Any"}>
                            Any
                        </MenuItem>
                        {createDropdowns()}
                    </Select>   
                </FormControl>
                <br></br>
                <TextField
                    label="Entity 2"
                    variant="outlined"
                    type="text"
                    id="entity2"
                    name="entity2"
                    value={values.molecule2}
                    onChange={handleChange("entity2")}
                /><br></br>
                <FormControl style={{minWidth: 200}}>
                    <InputLabel id="type2">Entity 2 Type</InputLabel>
                    <Select
                     labelId="type2"
                     id="type2"
                     value={types.type2}
                     onChange={handleTypeChange}
                     inputProps={{name: 'type2'}}
                     >
                        <MenuItem value={"Any"}>
                            Any
                        </MenuItem>
                        {createDropdowns()}
                    </Select>   
                </FormControl>
                <br></br>
                <Button type="submit" variant="contained" color="primary">
                    Submit
                </Button>
            </form>
        </div> 
    )

    

};

export default InteractionPage;