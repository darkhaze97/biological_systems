import React from "react";


const SpecificResultPage = (props) => {
    const data = props.location.state.response
    console.log(data)

    const handleEntity1 = () => {
        const entity1 = data.entity1
        return (
            <div>
                <h1>
                    {entity1.name} ({entity1.type})
                </h1>
                {Object.entries(entity1).map(([infoColumn, info]) => {
                    return (
                        <div>
                            {infoColumn !== "name" && infoColumn !== "type" && infoColumn !== "id" &&
                            (<h4>{infoColumn}: {info}</h4>)}
                        </div>
                    )
                })}
            </div>
        )
    }

    const handleEntity2 = () => {
        const entity2 = data.entity2
        return (
            <div>
                <h1>
                    {entity2.name} ({entity2.type})
                </h1>
                {Object.entries(entity2).map(([infoColumn, info]) => {
                    return (
                        <div>
                            {infoColumn !== "name" && infoColumn !== "type" && infoColumn !== "id" &&
                            (<h4>{infoColumn}: {info}</h4>)}
                        </div>
                    )
                })}
            </div>
        )
    }

    const handleInteractions = () => {
        const interactions = data.interactions
        //Interactions looks something like:
        //{'Coding': {'name': 'Blah', 'info': {'info1': 'blah', 'info2': 'blah'}}}

        //The ternary operator is required below so that we can account for printing
        //either the 'name' or the 'info' values, which can be a string or an object.
        return (
            <div>
                <h1 class="test">
                    INTERACTIONS:
                </h1>
                {Object.entries(interactions).map(([infoColumn, info]) => {
                    return (
                        <div>
                            <h2>
                                Category: {infoColumn}
                            </h2>
                            {Object.entries(info).map(([attr, attrInfo]) => {
                                return(
                                    <div>
                                        {typeof attrInfo !== "object" ? 
                                            (
                                                <h4>
                                                    {attr}: {attrInfo}
                                                </h4>
                                            ) : (
                                                <div>
                                                    {Object.entries(attrInfo).map(([attr2, attr2Info]) => {
                                                        return (
                                                            <h4>
                                                                {attr2}: {attr2Info}
                                                            </h4>
                                                        )
                                                    })}
                                                </div>
                                            )
                                        }
                                    </div>
                                )
                            })}
                        </div>
                    )
                })}
            </div>
        )
    }

    return (
        <div class="component-padding">
            <div class="rowC">
                <p class="Interaction-border">
                    {handleEntity1()}
                </p>
                <p class="Interaction-border">
                    {handleEntity2()}
                </p>
            </div>
            <p class="Interaction-border">
                    {handleInteractions()}
            </p>
        </div>
    )
};

export default SpecificResultPage;
